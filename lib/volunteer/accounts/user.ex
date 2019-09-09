defmodule Volunteer.Accounts.User do
  use Volunteer, :schema
  import Ecto.Changeset
  alias Volunteer.Accounts.Identity
  alias Volunteer.Apply.Applicant

  schema "users" do
    field :title, :string

    field :given_name, :string
    field :sur_name, :string

    field :primary_email, :string
    field :primary_phone, :string
    field :preferred_contact, {:array, :string}

    field :primary_jamatkhanas, {:array, :string}
    field :ismaili_status, :string

    field :education_level, :string

    has_many :identities, Identity

    has_many :applicants, Applicant

    timestamps()
  end

  @attributes_cast_always [
    :given_name,
    :sur_name,
    :primary_email,
    :primary_phone,
    :preferred_contact,
    # :primary_jamatkhanas,
    :ismaili_status,
    # :education_level
  ]

  @attributes_required_always @attributes_cast_always

  @defaults %{
    primary_email: "",
    primary_phone: "",
    preferred_contact: [],
    primary_jamatkhanas: [],
    ismaili_status: "",
    education_level: "",
  }

  def upsert_opts() do
    conflict_target = [:given_name, :sur_name, :primary_email, :primary_phone]
    fields_to_ignore = [:inserted_at]

    fields_to_replace =
      (((__schema__(:fields) -- __schema__(:primary_key)) -- conflict_target) -- fields_to_ignore)

    [
      conflict_target: conflict_target,
      on_conflict: {:replace, fields_to_replace}
    ]
  end

  def preferred_contact_choices() do
    [
      {"email", "Email"},
      {"phone", "Phone"},
    ]
  end

  def education_level_choices() do
    [
      {"primary", "Primary (Elementary)"},
      {"secondary", "Secondary (High School)"},
      {"diploma", "Diploma (ex. CEGEP, Associate's)"},
      {"undergraduate", "Undergraduate (ex. Bachelor's)"},
      {"postgraduate", "Postgraduate (ex. Master's, Doctoral)"},
    ]
  end

  def ismaili_status_choices() do
    [
      {"ismaili", "Ismaili"},
      {"non_with_ties", "Non-Ismaili, part of an Ismaili multi-faith family"},
      {"non_without_ties", "Non-Ismaili"},
      {"opted_out", "Prefer not to identify"},
    ]
  end

  def changeset(attrs) do
    changeset(%__MODULE__{}, attrs)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, @attributes_cast_always)
    |> Volunteer.StringSanitizer.sanitize_changes(@attributes_cast_always, %{type: :text})
    |> changeset_name()
    |> changeset_contact()
    |> validate_required(@attributes_required_always)
    |> validate_length(:preferred_contact, min: 1)
    |> validate_subset(:preferred_contact, (preferred_contact_choices() |> VolunteerUtils.Choices.values()))
    |> validate_inclusion(:ismaili_status, (ismaili_status_choices() |> VolunteerUtils.Choices.values()))
    # |> validate_inclusion(:education_level, (education_level_choices() |> VolunteerUtils.Choices.values()))
    # |> validate_length(:primary_jamatkhanas, min: 1, max: 1)
    # |> validate_subset(:primary_jamatkhanas, Volunteer.Infrastructure.jamatkhana_choices())
    |> optionally_cast_and_validate_primary_jamatkhanas(attrs)
    |> VolunteerUtils.Changeset.put_defaults(@defaults)
  end

  def changeset_authenticated(attrs) do
    changeset_authenticated(%__MODULE__{}, attrs)
  end

  def changeset_authenticated(user, attrs) do
    attributes_cast_and_required = [
      :given_name,
      :sur_name,
      :primary_email,
    ]

    user
    |> cast(attrs, attributes_cast_and_required)
    |> Volunteer.StringSanitizer.sanitize_changes(attributes_cast_and_required, %{type: :text})
    |> changeset_name()
    |> changeset_contact()
    |> validate_required(attributes_cast_and_required)
    |> VolunteerUtils.Changeset.put_defaults(@defaults)
  end

  def changeset_name(changeset) do
    changeset
    |> update_change(:given_name, &Volunteer.NameNormalizer.to_titlecase/1)
    |> update_change(:sur_name, &Volunteer.NameNormalizer.to_titlecase/1)
    |> title_from_names()
  end

  def changeset_contact(changeset) do
    changeset
    |> Volunteer.EmailNormalizer.validate_and_normalize_change(:primary_email)
    |> Volunteer.PhoneNormalizer.validate_and_normalize_change(:primary_phone)
  end

  def optionally_cast_and_validate_primary_jamatkhanas(changeset, attrs) do
    case fetch_field(changeset, :ismaili_status) do
      {_data_or_changes, ismaili_status} when ismaili_status in ["ismaili"] ->
        changeset
        |> cast(attrs, [:primary_jamatkhanas], empty_values: [[], [""]])
        |> Volunteer.StringSanitizer.sanitize_changes([:primary_jamatkhanas], %{type: :text})
        |> validate_required([:primary_jamatkhanas])
        |> validate_subset(:primary_jamatkhanas, Volunteer.Infrastructure.jamatkhana_choices())
        |> validate_length(:primary_jamatkhanas, min: 1, max: 1)

      {_data_or_changes, _ismaili_status} ->
        changeset

      :error ->
        # TODO: maybe add error here?
        changeset
    end
  end

  def title_from_names(%Ecto.Changeset{} = changeset) do
    put_change(
      changeset,
      :title,
      title_from_names(
        get_field(changeset, :given_name),
        get_field(changeset, :sur_name)
      )
    )
  end

  def title_from_names(given_name, sur_name) when is_binary(given_name) and is_binary(sur_name) do
    given_name <> " " <> sur_name
  end

  def title_from_names(_given_name, _sur_name) do
    ""
  end
end
