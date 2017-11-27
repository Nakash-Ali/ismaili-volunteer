defmodule Volunteer.Infrastructure do
  @moduledoc """
  The Infrastructure context.
  """

  import Ecto.Query, warn: false
  alias Volunteer.Repo

  alias Volunteer.Infrastructure.Region

  @doc """
  Returns the list of regions.

  ## Examples

      iex> list_regions()
      [%Region{}, ...]

  """
  def list_regions do
    Repo.all(Region)
  end

  @doc """
  Gets a single region.

  Raises `Ecto.NoResultsError` if the Region does not exist.

  ## Examples

      iex> get_region!(123)
      %Region{}

      iex> get_region!(456)
      ** (Ecto.NoResultsError)

  """
  def get_region!(id), do: Repo.get!(Region, id)

  @doc """
  Creates a region.

  ## Examples

      iex> create_region(%{field: value})
      {:ok, %Region{}}

      iex> create_region(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_region(attrs \\ %{}) do
    %Region{}
    |> Region.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a region.

  ## Examples

      iex> update_region(region, %{field: new_value})
      {:ok, %Region{}}

      iex> update_region(region, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_region(%Region{} = region, attrs) do
    region
    |> Region.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Region.

  ## Examples

      iex> delete_region(region)
      {:ok, %Region{}}

      iex> delete_region(region)
      {:error, %Ecto.Changeset{}}

  """
  def delete_region(%Region{} = region) do
    Repo.delete(region)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking region changes.

  ## Examples

      iex> change_region(region)
      %Ecto.Changeset{source: %Region{}}

  """
  def change_region(%Region{} = region) do
    Region.changeset(region, %{})
  end

  alias Volunteer.Infrastructure.Jamatkhana

  @doc """
  Returns the list of jamatkhanas.

  ## Examples

      iex> list_jamatkhanas()
      [%Jamatkhana{}, ...]

  """
  def list_jamatkhanas do
    Repo.all(Jamatkhana)
  end

  @doc """
  Gets a single jamatkhana.

  Raises `Ecto.NoResultsError` if the Jamatkhana does not exist.

  ## Examples

      iex> get_jamatkhana!(123)
      %Jamatkhana{}

      iex> get_jamatkhana!(456)
      ** (Ecto.NoResultsError)

  """
  def get_jamatkhana!(id), do: Repo.get!(Jamatkhana, id)

  @doc """
  Creates a jamatkhana.

  ## Examples

      iex> create_jamatkhana(%{field: value})
      {:ok, %Jamatkhana{}}

      iex> create_jamatkhana(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_jamatkhana(attrs \\ %{}) do
    %Jamatkhana{}
    |> Jamatkhana.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a jamatkhana.

  ## Examples

      iex> update_jamatkhana(jamatkhana, %{field: new_value})
      {:ok, %Jamatkhana{}}

      iex> update_jamatkhana(jamatkhana, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_jamatkhana(%Jamatkhana{} = jamatkhana, attrs) do
    jamatkhana
    |> Jamatkhana.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Jamatkhana.

  ## Examples

      iex> delete_jamatkhana(jamatkhana)
      {:ok, %Jamatkhana{}}

      iex> delete_jamatkhana(jamatkhana)
      {:error, %Ecto.Changeset{}}

  """
  def delete_jamatkhana(%Jamatkhana{} = jamatkhana) do
    Repo.delete(jamatkhana)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking jamatkhana changes.

  ## Examples

      iex> change_jamatkhana(jamatkhana)
      %Ecto.Changeset{source: %Jamatkhana{}}

  """
  def change_jamatkhana(%Jamatkhana{} = jamatkhana) do
    Jamatkhana.changeset(jamatkhana, %{})
  end

  alias Volunteer.Infrastructure.Group

  @doc """
  Returns the list of groups.

  ## Examples

      iex> list_groups()
      [%Group{}, ...]

  """
  def list_groups do
    Repo.all(Group)
  end

  @doc """
  Gets a single group.

  Raises `Ecto.NoResultsError` if the Group does not exist.

  ## Examples

      iex> get_group!(123)
      %Group{}

      iex> get_group!(456)
      ** (Ecto.NoResultsError)

  """
  def get_group!(id), do: Repo.get!(Group, id)

  @doc """
  Creates a group.

  ## Examples

      iex> create_group(%{field: value})
      {:ok, %Group{}}

      iex> create_group(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_group(attrs \\ %{}) do
    %Group{}
    |> Group.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a group.

  ## Examples

      iex> update_group(group, %{field: new_value})
      {:ok, %Group{}}

      iex> update_group(group, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_group(%Group{} = group, attrs) do
    group
    |> Group.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Group.

  ## Examples

      iex> delete_group(group)
      {:ok, %Group{}}

      iex> delete_group(group)
      {:error, %Ecto.Changeset{}}

  """
  def delete_group(%Group{} = group) do
    Repo.delete(group)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking group changes.

  ## Examples

      iex> change_group(group)
      %Ecto.Changeset{source: %Group{}}

  """
  def change_group(%Group{} = group) do
    Group.changeset(group, %{})
  end
end
