defmodule Volunteer.Infrastructure.Jamatkhana do
  use Ecto.Schema
  import Ecto.Changeset
  alias Volunteer.Infrastructure.Jamatkhana


  schema "jamatkhanas" do
    field :address_city, :string
    field :address_country, :string
    field :address_line_1, :string
    field :address_line_2, :string
    field :address_line_3, :string
    field :address_line_4, :string
    field :address_postal_zip_code, :string
    field :address_province_state, :string
    field :title, :string
    field :region, :id

    timestamps()
  end

  @doc false
  def changeset(%Jamatkhana{} = jamatkhana, attrs) do
    jamatkhana
    |> cast(attrs, [:title, :address_line_1, :address_line_2, :address_line_3, :address_line_4, :address_city, :address_province_state, :address_country, :address_postal_zip_code])
    |> validate_required([:title, :address_line_1, :address_line_2, :address_line_3, :address_line_4, :address_city, :address_province_state, :address_country, :address_postal_zip_code])
  end
end
