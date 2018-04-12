defmodule Volunteer.Infrastructure.Region do
  use Volunteer, :schema
  import Ecto.Changeset
  alias Volunteer.Infrastructure.Region
  alias Volunteer.Infrastructure.Jamatkhana
  alias Volunteer.Infrastructure.Group

  schema "regions" do
    field :title, :string
    field :parent_path, {:array, :id}, default: []

    belongs_to :parent, Region, foreign_key: :parent_id

    has_many :children, Region, foreign_key: :parent_id
    has_many :jamatkhanas, Jamatkhana
    has_many :groups, Group

    timestamps()
  end

  def changeset(region \\ %Region{}, attrs \\ %{}, parent \\ nil)

  def changeset(%Region{} = region, attrs, parent) when region == %Region{} do
    changes =
      region
      |> cast(attrs, [:title])
      |> validate_required([:title])

    case parent do
      nil ->
        changes

      %Region{} ->
        changes
        |> put_assoc(:parent, parent)
        |> put_change(:parent_path, parent_path(parent))
    end
    |> foreign_key_constraint(:parent_id)
  end

  defp parent_path(%Region{} = parent) do
    parent.parent_path ++ [parent.id]
  end
end
