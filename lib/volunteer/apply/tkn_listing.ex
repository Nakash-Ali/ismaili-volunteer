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

  @attributes_cast_always [
    :openings,
    :position_industry,
    :position_category,
    :listing_id
  ]

  @attributes_required_always @attributes_cast_always

  def changeset(%TKNListing{} = tkn_listing, %{} = attrs, %Listing{} = listing) do
    new_attrs =
      attrs
      |> Map.put("listing_id", listing.id)

    changeset(tkn_listing, new_attrs)
  end

  def changeset(%TKNListing{} = tkn_listing, %{} = attrs) do
    tkn_listing
    |> cast(attrs, @attributes_cast_always)
    |> validate_required(@attributes_required_always)
    |> foreign_key_constraint(:listing_id)
  end
end
