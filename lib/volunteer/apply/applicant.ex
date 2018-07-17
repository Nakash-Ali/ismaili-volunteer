defmodule Volunteer.Apply.Applicant do
  use Volunteer, :schema
  import Ecto.Changeset
  alias Volunteer.Apply.Listing
  alias Volunteer.Accounts.User

  schema "applicants" do
    field :preferred_contact, :string
    field :confirm_availability, :boolean, default: false

    field :additional_info, :string, default: ""
    field :hear_about, :string, default: ""

    belongs_to :listing, Listing
    belongs_to :user, User

    timestamps()
  end
  
  @attributes_cast_always [
    :listing_id,
    :user_id,
    :preferred_contact,
    :confirm_availability,
    :additional_info,
    :hear_about,
  ]

  @attributes_required_always [
    :listing_id,
    :user_id,
    :preferred_contact,
    :confirm_availability,
  ]
  
  def sanitize(attrs) do
    attrs
    |> Volunteer.SanitizeInput.text_attrs([
      "preferred_contact",
      "additional_info",
      "hear_about",
    ])
  end

  def changeset(applicant, attrs) do
    applicant
    |> cast(sanitize(attrs), @attributes_cast_always)
    |> validate_required(@attributes_required_always)
    |> foreign_key_constraint(:listing_id)
    |> foreign_key_constraint(:user_id)
  end
end
