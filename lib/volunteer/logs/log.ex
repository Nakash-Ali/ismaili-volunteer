defmodule Volunteer.Logs.Log do
  use Volunteer, :schema
  import Ecto.Changeset
  alias Volunteer.Accounts.User
  alias Volunteer.Infrastructure.Region
  alias Volunteer.Infrastructure.Group
  alias Volunteer.Listings.Listing

  schema "log" do
    field :ctx, :map
    belongs_to :user, User

    belongs_to :group, Group
    belongs_to :region, Region
    belongs_to :listing, Listing

    timestamps()
  end

  # TODO: use this to capture real things that aren't stored anywhere else:
  #   - approval requests
  #   - approve/unapprove
  #   - expiry reminder sent
  #   - marketing request sent
  #   - tkn assignment spec sent
end
