defmodule Volunteer.Infrastructure.Region do
  use Ecto.Schema
  import Ecto.Changeset
  alias Volunteer.Infrastructure.Region


  schema "regions" do
    field :parent_path, {:array, :id}
    field :title, :string
    field :parent, :id

    timestamps()
  end

  @doc false
  def changeset(%Region{} = region, attrs) do
    region
    |> cast(attrs, [:title, :parent_path])
    |> validate_required([:title, :parent_path])
  end
end
