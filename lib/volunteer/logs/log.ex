defmodule Volunteer.Logs.Log do
  use Volunteer, :schema
  alias Volunteer.Accounts.User
  alias Volunteer.Infrastructure.Region
  alias Volunteer.Infrastructure.Group
  alias Volunteer.Listings.Listing
  alias Volunteer.Apply.Applicant

  schema "log" do
    belongs_to :user, User
    field :type, :string
    field :ctx, :map

    belongs_to :group, Group
    belongs_to :region, Region
    belongs_to :listing, Listing
    belongs_to :applicant, Applicant

    # TODO: field :occured_at, timestamp with timezone

    timestamps()
  end

  # TODO: use this to capture real things that aren't stored anywhere else:
  #   - approval requests
  #   - approve/unapprove
  #   - expiry reminder sent
  #   - marketing request sent
  #   - tkn assignment spec sent
end
