defmodule Volunteer.Infrastructure.Address do
  use Volunteer, :schema
  import Ecto.Changeset

  schema "addresses" do
    field :city, :string
    field :region, :string
    field :code, :string
    field :country, :string
    field :line_1, :string
    field :line_2, :string, default: ""
    field :line_3, :string, default: ""
    field :line_4, :string, default: ""

    timestamps()
  end

  def changeset(address, attrs) do
    address
    |> cast(attrs, [:city, :region, :code, :country, :line_1, :line_2, :line_3, :line_4])
    |> validate_required([:city, :region, :code, :country, :line_1])
  end
end
