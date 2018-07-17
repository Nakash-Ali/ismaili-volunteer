defmodule Volunteer.Apply.Listing do
  use Volunteer, :schema
  use Timex
  import Ecto.Changeset
  alias Volunteer.Apply.TKNListing
  alias Volunteer.Infrastructure.Group
  alias Volunteer.Infrastructure.Region
  alias Volunteer.Accounts.User

  schema "listings" do
    field :expiry_date, :utc_datetime

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

    field :start_date, :date
    field :start_date_toggle, :boolean, virtual: true

    field :end_date, :date
    field :end_date_toggle, :boolean, virtual: true

    field :hours_per_week, :integer

    field :program_description, :string
    field :responsibilities, :string
    field :qualifications, :string
    
    field :cc_emails, :string, default: ""

    has_one :tkn_listing, TKNListing

    # TODO: CC'ed users (properly)
    # TODO: other attached users

    timestamps()
  end

  @refresh_expiry_days_by 14

  @attributes_cast_always [
    :position_title,
    :program_title,
    :summary_line,
    :region_id,
    :group_id,
    :organized_by_id,
    :start_date,
    :start_date_toggle,
    :end_date,
    :end_date_toggle,
    :hours_per_week,
    :program_description,
    :responsibilities,
    :qualifications,
    :cc_emails,
  ]

  @attributes_required_always [
    :position_title,
    :summary_line,
    :region_id,
    :group_id,
    :organized_by_id,
    :start_date_toggle,
    :end_date_toggle,
    :hours_per_week,
    :program_description,
    :responsibilities,
    :qualifications
  ]
  
  def preloadables() do
    [:created_by, :approved_by, :region, :group, :organized_by]
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
    |> cast(sanitize(attrs), [:created_by_id] ++ @attributes_cast_always)
    |> validate_required([:created_by_id] ++ @attributes_required_always)
    |> cast_assoc(:tkn_listing)
    |> changeset_common
    |> refresh_expiry
  end

  def edit(listing, attrs) do
    listing
    |> cast(sanitize(attrs), @attributes_cast_always)
    |> validate_required(@attributes_required_always)
    |> changeset_common
  end

  def approve(%__MODULE__{approved: false} = listing, %User{} = approved_by) do
    listing
    |> change
    |> put_change(:approved, true)
    |> put_change(:approved_on, Timex.now())
    |> put_assoc(:approved_by, approved_by)
    |> foreign_key_constraint(:approved_by_id)
    |> refresh_expiry
  end

  def unapprove(listing) do
    listing
    |> change
    |> put_change(:approved, false)
    |> put_change(:approved_on, nil)
    |> put_change(:approved_by, nil)
  end

  def is_approved?(%__MODULE__{approved: true}) do
    true
  end

  def is_approved?(%__MODULE__{approved: false}) do
    false
  end
  
  def expire(listing) do
    change(listing, %{
      expiry_date: now_expiry_date()
    })
  end

  def refresh_expiry(listing) do
    change(listing, %{
      expiry_date: refreshed_expiry_date()
    })
  end
  
  defp sanitize(attrs) do
    attrs
    |> Volunteer.SanitizeInput.text_attrs([
      "position_title",
      "program_title",
      "summary_line"
    ])
    |> Volunteer.SanitizeInput.html_attrs([
      "program_description",
      "qualifications",
      "responsibilities",
    ])
  end

  defp changeset_common(changeset) do
    changeset
    |> validate_length(:position_title, max: 140)
    |> validate_length(:program_title, max: 140)
    |> validate_length(:summary_line, max: 140)
    |> foreign_key_constraint(:region_id)
    |> foreign_key_constraint(:group_id)
    |> foreign_key_constraint(:created_by_id)
    |> foreign_key_constraint(:organized_by_id)
    |> manage_date_with_toggle(:start_date, :start_date_toggle)
    |> manage_date_with_toggle(:end_date, :end_date_toggle)
    |> manage_cc_emails_field
    |> unapprove
  end

  defp manage_date_with_toggle(changeset, date_field, toggle_field) do
    case get_field(changeset, toggle_field) do
      nil ->
        manage_toggle(changeset, date_field, toggle_field)

      true ->
        put_change(changeset, date_field, nil)

      false ->
        validate_required(changeset, date_field)
    end
  end

  defp manage_toggle(changeset, date_field, toggle_field) do
    case get_field(changeset, date_field) do
      nil ->
        put_change(changeset, toggle_field, true)

      _ ->
        put_change(changeset, toggle_field, false)
    end
  end
  
  defp manage_cc_emails_field(changeset) do
    field = :cc_emails
    re = ~r/^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i
    case get_field(changeset, field, "") do
      "" ->
        changeset
      raw_emails ->
        parsed_emails =
          raw_emails
          |> String.split(",")
          |> Enum.map(&String.trim/1)
        changeset =
          Enum.reduce(parsed_emails, changeset, fn email, changeset ->
            case Regex.match?(re, email) do
              true ->
                changeset
              _ ->
                add_error(changeset, field, "#{email} is not a valid email")
            end
          end)
        case Keyword.get(changeset.errors, field) do
          nil ->
            put_change(changeset, field, Enum.join(parsed_emails, ","))
          _ ->
            changeset
        end
    end
  end
  
  defp now_expiry_date() do
    Timex.now() |> Timex.shift(hours: -1) |> Timex.to_datetime()
  end

  defp refreshed_expiry_date() do
    Timex.now() |> Timex.shift(days: @refresh_expiry_days_by) |> Timex.to_datetime()
  end
end
