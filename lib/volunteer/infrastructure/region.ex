defmodule Volunteer.Infrastructure.Region do
  use Volunteer, :schema
  import Ecto.Changeset
  alias Volunteer.Infrastructure.Region
  alias Volunteer.Infrastructure.Jamatkhana
  alias Volunteer.Infrastructure.Group

  schema "regions" do
    has_many :roles, Volunteer.Roles.Role

    field :title, :string
    field :slug, :string
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
      |> cast(attrs, [:title, :slug])
      |> validate_required([:title])
      |> slugify_if_not_present(:slug, :title)
      |> validate_required([:slug])
      |> unique_constraint(:slug)

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

  def slugify(title) do
    Slugger.slugify_downcase(title, "-")
  end

  def slugify_if_not_present(changeset, slug_field, source_field) do
    case get_field(changeset, slug_field) do
      slug when is_binary(slug) ->
        changeset

      _ ->
        slug =
          changeset
          |> get_field(source_field)
          |> slugify

        put_change(changeset, slug_field, slug)
    end
  end

  defp parent_path(%Region{} = parent) do
    parent.parent_path ++ [parent.id]
  end
end
