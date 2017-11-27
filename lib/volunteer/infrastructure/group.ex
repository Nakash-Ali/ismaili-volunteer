defmodule Volunteer.Infrastructure.Group do
  use Ecto.Schema
  import Ecto.Changeset
  alias Volunteer.Infrastructure.Group


  schema "groups" do
    field :parent_path, {:array, :id}
    field :title, :string
    field :parent, :id
    field :region, :id

    timestamps()
  end

  @doc false
  def changeset(%Group{} = group, attrs) do
    group
    |> cast(attrs, [:title, :parent_path])
    |> validate_required([:title, :parent_path])
  end
end
