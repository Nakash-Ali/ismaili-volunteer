defmodule Volunteer.Legacy do
  alias Ecto.Changeset

  @all_jamatkhanas [
    "Barrie",
    "Belleville",
    "Bobcaygeon",
    "Brampton",
    "Brantford",
    "Don Mills",
    "Downtown",
    "Durham",
    "East York",
    "Etobicoke",
    "Guelph",
    "Halton",
    "Hamilton",
    "Headquarters",
    "Kitchener",
    "London",
    "Meadowvale",
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
    this_id: :string,
    cc: {:array, :string},
    organizer: :string,
    organizer_email: :string,
    submission_id: :string
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
    :this,
    :this_id,
    :organizer,
    :organizer_email,
    :submission_id
  ]

  @public_keys [
    {:name, "Full name"},
    {:email, "Email"},
    {:phone, "Phone"},
    {:preferred_contact, "Preferred method of contact"},
    {:jamatkhana, "Jamatkhana"},
    {:affirm, "Affirm availability"},
    {:other_info, "Additional information"},
    {:hear_about, "How did you hear about this website?"}
  ]

  @system_keys [
    {:position, "Position"},
    {:program, "Program"},
    {:organizer, "Organizer"},
    {:organizer_email, "Organizer's email"},
    {:cc, "CC"},
    {:this, "Listing URL"},
    {:this_id, "Listing ID"},
    {:submission_id, "Submission ID"}
  ]

  defstruct Map.keys(@types) |> Enum.map(fn key -> {key, Map.get(@defaults, key, nil)} end)
  
  def all_jamatkhanas do
    @all_jamatkhanas
  end

  def apply(attrs) when is_map(attrs) do
    changeset =
      {%{}, @types}
      |> Changeset.cast(attrs, Map.keys(@types))
      |> Changeset.validate_required(@required)
      |> Changeset.validate_format(:email, ~r/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b/i)
      |> Changeset.validate_inclusion(:jamatkhana, @all_jamatkhanas)
      |> Changeset.validate_inclusion(:preferred_contact, @all_contact_methods)
      |> Changeset.validate_acceptance(:affirm)

    with %{valid?: true} <- changeset,
         data <- struct(Volunteer.Legacy, changeset |> Changeset.apply_changes()),
         sent_emails <- send_emails(data) do
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

  defp get_keys_config(:system) do
    @system_keys
  end

  defp get_keys_config(:public) do
    @public_keys
  end

  defp send_emails(%Volunteer.Legacy{} = data) do
    [
      &VolunteerEmail.LegacyEmails.external/1,
      &VolunteerEmail.LegacyEmails.internal/1,
    ]
    |> Enum.map(&(&1.(data)))
    |> Enum.map(&VolunteerEmail.Mailer.deliver_now/1)
  end
end
