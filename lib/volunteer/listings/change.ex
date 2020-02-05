defmodule Volunteer.Listings.Change do
  import Ecto.Changeset
  alias Volunteer.Accounts.User
  alias Volunteer.Listings.Listing
  alias Volunteer.Listings.Public

  @attributes_cast_always [
    :position_title,
    :program_title,
    :summary_line,
    :region_id,
    :group_id,
    :organized_by_id,
    :cc_emails,
    :start_date,
    :start_date_toggle,
    :end_date,
    :end_date_toggle,
    :time_commitment_amount,
    :time_commitment_type,
    :program_description,
    :responsibilities,
    :qualifications,
    :qualifications_required,
  ]

  @attributes_required_always [
    :position_title,
    :summary_line,
    :region_id,
    :group_id,
    :organized_by_id,
    :start_date_toggle,
    :end_date_toggle,
    :time_commitment_amount,
    :time_commitment_type,
    :program_description,
    :responsibilities,
    :qualifications
  ]

  @attributes_sanitize_text [
    :position_title,
    :program_title,
    :summary_line,
    :qualifications_required,
  ]

  @attributes_sanitize_html [
    :program_description,
    :responsibilities,
    :qualifications,
  ]

  @attributes_sanitize_comma_separated_text [
    :cc_emails
  ]

  @max_char_counts %{
    position_title: 120,
    program_title: 120,
    summary_line: 240,
  }

  def max_char_counts() do
    @max_char_counts
  end

  def qualifications_required_choices() do
    [
      {"criminal_record_check", "Criminal record check"},
      {"car_and_driver", "Valid driver’s license and access to a vehicle"},
    ]
  end

  def time_commitment_type_choices() do
    [
      "day(s)",
      "day(s)/week",
      "day(s)/month",
      "hour(s)",
      "hour(s)/week",
      "hour(s)/month"
    ]
  end

  def draft_content(organized_by_id) do
    %{
      position_title: "Draft position...",
      summary_line: "Draft summary...",
      time_commitment_amount: "1",
      organized_by_id: organized_by_id,
      start_date: Date.utc_today() |> Date.to_iso8601(),
      end_date: Date.utc_today() |> Date.add(30) |> Date.to_iso8601(),
      program_description: "Draft description...",
      responsibilities: "Draft responsibilities...",
      qualifications: "Draft qualifications..."
    }
  end

  def new() do
    create(%{})
  end

  def create(attrs, %User{} = user) do
    attrs
    |> Map.put("created_by_id", user.id)
    |> create()
  end

  def create(attrs) do
    %Listing{}
    |> cast(attrs, [:created_by_id] ++ @attributes_cast_always)
    |> sanitize()
    |> validate_required([:created_by_id] ++ @attributes_required_always)
    |> changeset_common
  end

  def edit(listing, attrs) do
    listing
    |> cast(attrs, @attributes_cast_always)
    |> sanitize()
    |> validate_required(@attributes_required_always)
    |> changeset_common
  end

  defp sanitize(changeset) do
    changeset
    |> Volunteer.StringSanitizer.sanitize_changes(@attributes_sanitize_text, %{type: :text})
    |> Volunteer.StringSanitizer.sanitize_changes(@attributes_sanitize_html, %{type: :html})
    |> Volunteer.StringSanitizer.sanitize_changes(@attributes_sanitize_comma_separated_text, %{type: {:comma_separated, :text}})
  end

  defp changeset_common(changeset) do
    changeset
    |> validate_length(:position_title, max: @max_char_counts.position_title)
    |> validate_length(:program_title, max: @max_char_counts.program_title)
    |> validate_length(:summary_line, max: @max_char_counts.summary_line)
    |> validate_number(:time_commitment_amount, greater_than: 0)
    |> validate_inclusion(:time_commitment_type, time_commitment_type_choices())
    |> validate_subset(:qualifications_required, qualifications_required_choices() |> VolunteerUtils.Choices.values())
    |> foreign_key_constraint(:region_id)
    |> foreign_key_constraint(:group_id)
    |> foreign_key_constraint(:created_by_id)
    |> foreign_key_constraint(:organized_by_id)
    |> manage_date_with_toggle(:start_date, :start_date_toggle)
    |> manage_date_with_toggle(:end_date, :end_date_toggle)
    |> Volunteer.EmailNormalizer.validate_and_normalize_change(:cc_emails, %{type: :comma_separated})
    |> Public.Change.unapprove
  end

  defp manage_date_with_toggle(changeset, date_field, disable_date_toggle) do
    default_toggle_value = false

    case get_field(changeset, disable_date_toggle) do
      nil ->
        case get_field(changeset, date_field) do
          nil ->
            put_change(changeset, disable_date_toggle, default_toggle_value)

          _ ->
            put_change(changeset, disable_date_toggle, false)
        end

      true ->
        put_change(changeset, date_field, nil)

      false ->
        validate_required(changeset, date_field)
    end
  end
end
