defmodule Volunteer.Apply.TKNListing do
  use Volunteer, :schema
  import Ecto.Changeset
  alias Volunteer.Apply.TKNListing


  schema "tkn_listings" do
    field :openings, :integer

    field :position_category, :string
    field :position_industry, :string

    timestamps()
  end

  def changeset(%TKNListing{} = tkn_listing, attrs) do
    tkn_listing
    |> cast(attrs, [:openings, :position_industry, :position_category])
    |> validate_required([:openings, :position_industry, :position_category])
  end
end
