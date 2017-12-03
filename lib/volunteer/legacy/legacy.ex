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
    jamatkhana: :string,
    preferred_contact: :string,
    other_info: :string,
    hear_about: :string,
    affirm: :boolean,
    position: :string,
    program: :string,
    this: :string,
    cc: {:array, :string},
    organizer: :string,
    organizer_email: :string
  }

  @required [
    :name,
    :email,
    :phone,
    :jamatkhana,
    :preferred_contact,
    :affirm,
    :position,
    :program,
    :this,
    :cc,
    :organizer,
    :organizer_email,
  ]

  @public_keys [
    {:name, "Name"},
    {:email, "Email"},
    {:phone, "Phone"},
    {:jamatkhana, "Jamatkhana"},
    {:preferred_contact, "Preferred method of contact"},
    {:other_info, "Additional information"},
    {:hear_about, "How did you hear about this website?"},
    {:affirm, "Affirm"},
  ]

  @system_keys [
    {:position, "Position"},
    {:program, "Program"},
    {:this, "This"},
    {:cc, "CC"},
    {:organizer, "Organizer"},
    {:organizer_email, "Organizer's email"},
  ]

  defstruct Map.keys(@types)

  def apply(params) when is_map(params) do
    changeset = {%{}, @types}
      |> Changeset.cast(params, Map.keys(@types))
      |> Changeset.validate_required(@required)
      |> Changeset.validate_format(:email, ~r/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b/i)
      |> Changeset.validate_inclusion(:jamatkhana, @all_jamatkhanas)
      |> Changeset.validate_inclusion(:preferred_contact, @all_contact_methods)
      |> Changeset.validate_acceptance(:affirm)

    with %{valid?: true} <- changeset,
         data <- struct(Volunteer.Legacy, changeset.changes),
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
    email = Mailer.default_email()
      |> to({data.name, data.email})
      |> cc([{data.organizer, data.organizer_email} | data.cc])
      |> subject(construct_subject(data))
      |> put_header("Reply-To", data.organizer_email)
    render_email(VolunteerEmail.LegacyView, email, :external_for_new_application, [data: data])
  end

  defp internal_email(%Volunteer.Legacy{} = data) do
    email = Mailer.default_email()
      |> to({data.organizer, data.organizer_email})
      |> cc(data.cc)
      |> subject("INTERNAL - #{data.name} - #{construct_subject(data)}")
    render_email(VolunteerEmail.LegacyView, email, :internal_for_new_application, [data: data])
  end

  defp construct_subject(%Volunteer.Legacy{} = data) do
    "#{data.position} - #{data.program} - Volunteer Application"
  end
end
