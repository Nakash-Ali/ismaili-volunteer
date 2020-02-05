defmodule Volunteer.Apply.Applicant do
  use Volunteer, :schema
  import Ecto.Changeset
  alias Volunteer.Listings.Listing
  alias Volunteer.Accounts.User

  schema "applicants" do
    # TODO: enable editing functionality through opaque IDs (instead of overwriting!)
    field :opaque_id, :binary_id

    belongs_to :listing, Listing
    belongs_to :user, User

    field :confirm_availability, :boolean, default: false

    field :additional_info, :string, default: ""
    field :hear_about, :string, default: ""

    timestamps()
  end

  @attributes_cast_always [
    :listing_id,
    :user_id,
    :confirm_availability,
    :additional_info,
    :hear_about
  ]

  @attributes_sanitize_text [
    :additional_info,
    :hear_about,
  ]

  def create(attrs, listing, user) do
    %__MODULE__{}
    |> cast(attrs, @attributes_cast_always)
    |> Volunteer.StringSanitizer.sanitize_changes(@attributes_sanitize_text, %{type: :text})
    |> common_changeset_funcs(listing, user)
    |> validate_required([:listing_id, :user_id, :confirm_availability])
  end

  def update(applicant, attrs, listing, user) do
    applicant
    |> cast(attrs, @attributes_cast_always)
    |> Volunteer.StringSanitizer.sanitize_changes(@attributes_sanitize_text, %{type: :text})
    |> common_changeset_funcs(listing, user)
  end

  def common_changeset_funcs(changeset, listing, user) do
    changeset
    |> unique_constraint(:unique_applicant, name: :applicants_listing_id_user_id_index)
    |> foreign_key_constraint(:listing_id)
    |> foreign_key_constraint(:user_id)
    |> validate_acceptance(:confirm_availability)
    |> put_id_if_exists(:listing_id, listing)
    |> put_id_if_exists(:user_id, user)
  end

  def put_id_if_exists(changeset, field, %{id: id}) do
    put_change(changeset, field, id)
  end

  def put_id_if_exists(changeset, _field, _map) do
    changeset
  end
end
