defmodule Volunteer.Legacy do
  import Ecto.Changeset

  @all_jamatkhanas [
    "Barrie",
    "Belleville",
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
    "Peterborough",
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

  def changeset(attrs) when is_map(attrs) do
    {%{}, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_required(@required)
    |> validate_inclusion(:jamatkhana, @all_jamatkhanas)
    |> validate_inclusion(:preferred_contact, @all_contact_methods)
    |> validate_acceptance(:affirm)
    |> Volunteer.EmailNormalizer.validate_and_normalize_change(:email)
    |> Volunteer.EmailNormalizer.validate_and_normalize_change(:organizer_email)
    |> Volunteer.EmailNormalizer.validate_and_normalize_change(:cc, %{type: :list, filter_empty: true})
  end

  def apply(attrs) do
    with %{valid?: true} = changes <- changeset(attrs),
         data <- struct(Volunteer.Legacy, apply_changes(changes)),
         sent_emails <- send_emails(data) do
      {:ok, data, sent_emails}
    else
      %Ecto.Changeset{valid?: false} = changes -> {:error, changes}
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
      &VolunteerEmail.LegacyEmails.internal/1
    ]
    |> Enum.map(& &1.(data))
    |> Enum.map(&VolunteerEmail.Mailer.deliver_now!/1)
  end
end
