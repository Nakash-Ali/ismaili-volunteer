defmodule Volunteer.Apply.TKNListing do
  use Volunteer, :schema
  import Ecto.Changeset
  alias Volunteer.Apply.TKNListing
  alias Volunteer.Apply.Listing


  schema "tkn_listings" do
    field :openings, :integer
    field :position_category, :string
    field :position_industry, :string

    belongs_to :listing, Listing

    timestamps()
  end

  def changeset(%TKNListing{} = tkn_listing, attrs) do
    tkn_listing
    |> cast(attrs, [:listing_id, :openings, :position_industry, :position_category])
    |> validate_required([:listing_id, :openings, :position_industry, :position_category])
  end
end
