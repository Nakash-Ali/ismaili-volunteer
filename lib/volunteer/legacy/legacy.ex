require IEx

defmodule Volunteer.Legacy do
  alias Ecto.Changeset
  alias VolunteerEmail.Mailer

  import Bamboo.Email
  import Bamboo.Phoenix

  @all_jamatkhanas [
    "Headquarters",
    "Barrie",
    "Belleville",
    "Bobcaygeon",
    "Brampton",
    "Brantford",
    "Don Mills",
    "Downtown",
    "East York",
    "Etobicoke",
    "Guelph",
    "Halton",
    "Hamilton",
    "Kitchener",
    "London",
    "Mississauga",
    "Niagara Falls",
    "Oshawa",
    "Pickering",
    "Richmond Hill",
    "Scarborough",
    "St. Thomas",
    "Sudbury",
    "Unionville",
    "Willowdale",
    "Windsor"
  ]

  @all_contact_methods [
    "phone",
    "email"
  ]

  @types %{
    name: :string,
    email: :string,
    phone: :string,
    preferred_contact: :string,
    jamatkhana: :string,
    affirm: :boolean,
    other_info: :string,
    hear_about: :string,
    position: :string,
    program: :string,
    this: :string,
    cc: {:array, :string},
    organizer: :string,
    organizer_email: :string
  }

  @defaults %{
    cc: []
  }

  @required [
    :name,
    :email,
    :phone,
    :preferred_contact,
    :jamatkhana,
    :affirm,
    :position,
    :program,
    :this,
    :organizer,
    :organizer_email,
  ]

  @public_keys [
    {:name, "Full name"},
    {:email, "Email"},
    {:phone, "Phone"},
    {:preferred_contact, "Preferred method of contact"},
    {:jamatkhana, "Jamatkhana"},
    {:affirm, "Affirm availability"},
    {:other_info, "Additional information"},
    {:hear_about, "How did you hear about this website?"},
  ]

  @system_keys [
    {:this, "Listing ID"},
    {:position, "Position"},
    {:program, "Program"},
    {:organizer, "Organizer"},
    {:organizer_email, "Organizer's email"},
    {:cc, "CC"},
  ]

  defstruct Map.keys(@types) |> Enum.map(fn key -> {key, Map.get(@defaults, key, nil)} end)

  def apply(params) when is_map(params) do
    changeset = {%{}, @types}
      |> Changeset.cast(params, Map.keys(@types))
      |> Changeset.validate_required(@required)
      |> Changeset.validate_format(:email, ~r/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b/i)
      |> Changeset.validate_inclusion(:jamatkhana, @all_jamatkhanas)
      |> Changeset.validate_inclusion(:preferred_contact, @all_contact_methods)
      |> Changeset.validate_acceptance(:affirm)

    with %{valid?: true} <- changeset,
         data <- struct(Volunteer.Legacy, changeset |> Changeset.apply_changes),
         sent_emails <- send_emails(data)
    do
      {:ok, data, sent_emails}
    else
      %Ecto.Changeset{valid?: false} -> {:error, changeset}
      {:error, error} -> {:error, error}
    end
  end

  def translate_keys(type, data, opts \\ [])

  def translate_keys(type, data, replace_keys: true) do
    translate_keys(type, data)
      |> Enum.map(fn {_, translated_key, value} -> {translated_key, value} end)
  end

  def translate_keys(type, data, _) do
    get_keys_config(type)
      |> Enum.filter(fn {key, _} -> Map.has_key?(data, key) end)
      |> Enum.map(fn {key, translated_key} -> {key, translated_key, Map.get(data, key)} end)
  end

  defp get_keys_config(type)
  defp get_keys_config(:system) do @system_keys end
  defp get_keys_config(:public) do @public_keys end

  defp send_emails(%Volunteer.Legacy{} = data) do
    [
      data |> external_email |> Mailer.deliver_now,
      data |> internal_email |> Mailer.deliver_now,
    ]
  end

  defp external_email(%Volunteer.Legacy{} = data) do
    email = Mailer.new_default_email()
      |> to({data.name, data.email})
      |> cc([Mailer.from_email(), {data.organizer, data.organizer_email} | data.cc])
      |> subject(construct_subject(data))
    render_email(VolunteerEmail.LegacyView, email, :external_for_new_application, [data: data])
  end

  defp internal_email(%Volunteer.Legacy{} = data) do
    email = Mailer.new_default_email()
      |> to({data.organizer, data.organizer_email})
      |> cc([Mailer.from_email() | data.cc])
      |> subject("INTERNAL - #{construct_subject(data)}")
    render_email(VolunteerEmail.LegacyView, email, :internal_for_new_application, [data: data])
  end

  defp construct_subject(%Volunteer.Legacy{} = data) do
    "#{data.name} - #{data.position} - #{data.program} - Volunteer Application"
  end
end
