defmodule Volunteer.Apply.Application do
  use Volunteer, :schema
  import Ecto.Changeset
  alias Volunteer.Apply.Application
  alias Volunteer.Apply.Listing
  alias Volunteer.Accounts.User

  schema "applications" do
    field :preferred_contact, :string
    field :confirm_availability, :boolean, default: false

    field :additional_info, :string, default: ""
    field :hear_about, :string, default: ""

    belongs_to :listing, Listing
    belongs_to :user, User

    timestamps()
  end

  def changeset(%Application{} = application, attrs) when application == %Application{} do
    application
    |> cast(attrs, [
      :listing_id,
      :user_id,
      :preferred_contact,
      :confirm_availability,
      :additional_info,
      :hear_about
    ])
    |> validate_required([:listing_id, :user_id, :preferred_contact, :confirm_availability])
    |> foreign_key_constraint(:listing_id)
    |> foreign_key_constraint(:user_id)
  end
end
