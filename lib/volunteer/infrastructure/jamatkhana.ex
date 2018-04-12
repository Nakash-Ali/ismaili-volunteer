defmodule Volunteer.Infrastructure.Jamatkhana do
  use Volunteer, :schema
  import Ecto.Changeset
  alias Volunteer.Infrastructure.Jamatkhana
  alias Volunteer.Infrastructure.Region
  alias Volunteer.Infrastructure.Address

  schema "jamatkhanas" do
    field :title, :string

    belongs_to :region, Region
    belongs_to :address, Address

    timestamps()
  end

  def changeset(group \\ %Jamatkhana{}, attrs \\ %{}, region \\ nil)

  def changeset(jamatkhana, attrs, region_id) when is_integer(region_id) do
    attrs = Map.put(attrs, :region_id, region_id)
    changeset(jamatkhana, attrs, nil)
  end

  def changeset(%Jamatkhana{} = jamatkhana, attrs, region) when jamatkhana == %Jamatkhana{} do
    case region do
      nil ->
        jamatkhana
        |> cast(attrs, [:title, :region_id])
        |> validate_required([:title, :region_id])

      %Region{} ->
        jamatkhana
        |> cast(attrs, [:title])
        |> validate_required([:title])
        |> put_assoc(:region, region)
    end
    |> cast_assoc(:address)
  end
end
