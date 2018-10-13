defmodule Volunteer.Infrastructure.Group do
  use Volunteer, :schema
  import Ecto.Changeset
  alias Volunteer.Infrastructure.Group
  alias Volunteer.Infrastructure.Region

  schema "groups" do
    field :title, :string
    belongs_to :region, Region

    # field :parent_path, {:array, :id}, default: []
    # belongs_to :parent, Group, foreign_key: :parent_id
    # has_many :children, Group, foreign_key: :parent_id

    timestamps()
  end

  def changeset(group \\ %Group{}, attrs \\ %{}, region \\ nil)

  def changeset(group, attrs, region_id) when is_integer(region_id) do
    attrs = Map.put(attrs, :region_id, region_id)
    changeset(group, attrs, nil)
  end

  def changeset(group, attrs, %Region{} = region) when group == %Group{} do
    group
    |> cast(attrs, [:title])
    |> validate_required([:title])
    |> put_assoc(:region, region)
  end

  def changeset(group, attrs, nil) when group == %Group{} do
    group
    |> cast(attrs, [:title, :region_id])
    |> validate_required([:title, :region_id])
  end

  # def changeset(group, attrs, region, parent) when group == %Group{} do
  #   case parent do
  #     nil ->
  #       changes
  #
  #     %Group{} ->
  #       changes
  #       |> put_assoc(:parent, parent)
  #       |> put_change(:parent_path, parent_path(parent))
  #   end
  # end
  #
  # defp parent_path(%Group{} = parent) do
  #   parent.parent_path ++ [parent.id]
  # end
end
