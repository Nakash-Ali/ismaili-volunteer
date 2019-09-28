defmodule Volunteer.Listings.Listing do
  use Volunteer, :schema
  use Timex
  import Ecto.Changeset
  alias Volunteer.Listings.TKNListing
  alias Volunteer.Infrastructure.Group
  alias Volunteer.Infrastructure.Region
  alias Volunteer.Accounts.User

  schema "listings" do
    has_many :roles, Volunteer.Roles.Role

    field :expiry_date, :utc_datetime
    field :expiry_reminder_sent, :boolean

    belongs_to :created_by, User

    field :approved, :boolean, default: false
    field :approved_on, :utc_datetime
    belongs_to :approved_by, User, on_replace: :nilify

    field :position_title, :string
    field :program_title, :string, default: ""
    field :summary_line, :string
    belongs_to :region, Region
    belongs_to :group, Group
    belongs_to :organized_by, User

    field :cc_emails, :string, default: ""

    field :start_date, :date
    field :start_date_toggle, :boolean, virtual: true

    field :end_date, :date
    field :end_date_toggle, :boolean, virtual: true

    field :time_commitment_amount, :integer
    field :time_commitment_type, :string

    field :program_description, :string
    field :responsibilities, :string
    field :qualifications, :string

    field :qualifications_required, {:array, :string}

    has_one :tkn_listing, TKNListing

    # TODO: CC'ed users (properly)
    # TODO: other attached users

    timestamps()
  end

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

  def refresh_expiry_days_by() do
    14
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
    %__MODULE__{}
    |> cast(attrs, [:created_by_id] ++ @attributes_cast_always)
    |> sanitize()
    |> validate_required([:created_by_id] ++ @attributes_required_always)
    |> cast_assoc(:tkn_listing)
    |> changeset_common
    |> refresh_expiry
  end

  def edit(listing, attrs) do
    listing
    |> cast(attrs, @attributes_cast_always)
    |> sanitize()
    |> validate_required(@attributes_required_always)
    |> changeset_common
  end

  def approve_if_not_expired(listing, user) do
    if is_expired?(listing) do
      listing
      |> change()
      |> add_error(:approved, "cannot approve expired listing")
    else
      approve(listing, user)
    end
  end

  def unapprove_if_not_expired(listing) do
    if is_expired?(listing) do
      listing
      |> change()
      |> add_error(:approved, "cannot unapprove expired listing")
    else
      unapprove(listing)
    end
  end

  defp approve(%__MODULE__{approved: false} = listing, %User{} = approved_by) do
    listing
    |> change()
    |> put_change(:approved, true)
    |> put_change(:approved_on, VolunteerUtils.Temporal.utc_now_truncated_to_seconds())
    |> put_assoc(:approved_by, approved_by)
    |> foreign_key_constraint(:approved_by_id)
  end

  defp unapprove(listing) do
    listing
    |> change()
    |> put_change(:approved, false)
    |> put_change(:approved_on, nil)
    |> put_change(:approved_by, nil)
  end

  def expire(listing) do
    change(listing, %{
      expiry_date: now_expiry_date()
    })
  end

  def refresh_and_maybe_unapprove(listing) do
    if is_expired?(listing) do
      unapprove(listing)
    else
      listing
    end
    |> refresh_expiry()
  end

  defp refresh_expiry(listing) do
    change(listing, %{
      expiry_date: refreshed_expiry_date(),
      expiry_reminder_sent: false
    })
  end

  def expiry_reminder_sent(listing) do
    change(listing, %{
      expiry_reminder_sent: true
    })
  end

  def get_cc_emails(%{cc_emails: ""}) do
    []
  end

  def get_cc_emails(%{cc_emails: cc_emails}) do
    String.split(cc_emails, ",")
  end

  def is_approved?(%__MODULE__{approved: approved}) do
    approved
  end

  def is_expired?(%__MODULE__{expiry_date: expiry_date}) do
    Timex.compare(VolunteerUtils.Temporal.utc_now_truncated_to_seconds(), expiry_date) == 1
  end

  def is_public?(listing) do
    is_approved?(listing) and not is_expired?(listing)
  end

  def is_previewable?(listing) do
    not is_approved?(listing) and not is_expired?(listing)
  end

  def is_delete_allowed?(listing) do
    is_expired?(listing)
  end

  def is_approve_allowed?(listing) do
    is_expired?(listing) == false
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
    |> unapprove
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

  def now_expiry_date() do
    VolunteerUtils.Temporal.utc_now_truncated_to_seconds()
    |> Timex.shift(minutes: -5)
    |> Timex.to_datetime("UTC")
  end

  def refreshed_expiry_date() do
    VolunteerUtils.Temporal.utc_now_truncated_to_seconds()
    |> Timex.shift(days: refresh_expiry_days_by())
    |> Timex.to_datetime("UTC")
  end
end
