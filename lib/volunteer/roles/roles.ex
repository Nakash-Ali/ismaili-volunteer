defmodule Volunteer.Roles do
  import Ecto.Query

  alias Volunteer.Repo
  alias Volunteer.Roles.Role
  alias Volunteer.Accounts.User

  @preloads %{
    region: [:parent],
    group: [:region],
    listing: [:region]
  }

  def get_subject!(subject_type, subject_id) do
    subject_type
    |> Role.module_for_subject_type()
    |> Repo.get!(subject_id)
    |> Repo.preload(@preloads[subject_type])
  end

  def get_subject_roles(subject_type, subject_id) do
    from(r in Role)
    |> query_subject_roles(subject_type, subject_id)
    |> order_by(desc: :inserted_at)
    |> Repo.all
    |> Repo.preload([:user])
  end

  def get_user_roles(%User{id: user_id}) do
    get_user_roles(user_id)
  end

  def get_user_roles(user_id) do
    from(r in Role)
    |> query_user_roles(user_id)
    |> Repo.all
  end

  def get_user_roles(user_id, subject_type) do
    from(r in Role)
    |> query_user_roles(user_id)
    |> query_subject_roles(subject_type)
    |> Repo.all
  end

  def get_user_roles(user_id, subject_type, relations_to_include) do
    from(r in Role)
    |> query_user_roles(user_id)
    |> query_subject_roles(subject_type)
    |> query_relations_to_include(relations_to_include)
    |> Repo.all
  end

  def get_all_users_with_roles() do
    from(
      u in User,
      where: u.id in fragment("select distinct(r.user_id) from roles r")
    )
    |> Repo.all
    |> Repo.preload(:roles)
  end

  def get_users_with_subject_roles(subject_type, subject_id, relations_to_include) do
    subquery =
      from(r in Role, select: r.user_id)
      |> query_subject_roles(subject_type, subject_id)
      |> query_relations_to_include(relations_to_include)

    from(u in User, join: r in ^subquery, on: u.id == r.user_id)
    |> Repo.all
  end

  def new_subject_role(subject_type, subject_id) do
    Role.new(subject_type, subject_id)
  end

  def create_subject_role(subject_type, subject_id, attrs) do
    Role.create(subject_type, subject_id, attrs)
    |> Repo.insert
  end

  def delete_subject_role!(subject_type, subject_id, role_id) do
    from(r in Role)
    |> query_subject_roles(subject_type, subject_id)
    |> query_role_id(role_id)
    |> Repo.one!
    |> Repo.delete!
  end

  # TODO: Move this back to the listings service!
  def create_roles_for_new_listing!(listing) do
    {:ok, _role} =
      create_subject_role(
        :listing,
        listing.id,
        %{user_id: listing.created_by_id, relation: "admin"}
      )
  end

  def query_role_id(query, role_id) do
    from(r in query, where: r.id == ^role_id)
  end

  def query_user_roles(query, user_id) do
    from(r in query, where: r.user_id == ^user_id)
  end

  def query_subject_roles(query, :region) do
    from(r in query, where: not is_nil(r.region_id))
  end

  def query_subject_roles(query, :group) do
    from(r in query, where: not is_nil(r.group_id))
  end

  def query_subject_roles(query, :listing) do
    from(r in query, where: not is_nil(r.listing_id))
  end

  def query_subject_roles(query, :region, region_id) do
    from(r in query, where: r.region_id == ^region_id)
  end

  def query_subject_roles(query, :group, group_id) do
    from(r in query, where: r.group_id == ^group_id)
  end

  def query_subject_roles(query, :listing, listing_id) do
    from(r in query, where: r.listing_id == ^listing_id)
  end

  def query_relations_to_include(query, relations_to_include) do
    from(r in query, where: r.relation in ^relations_to_include)
  end

  def collate_roles_by_subject_type(roles) when is_list(roles) do
    Enum.reduce(roles, %{}, fn role, accum ->
      {subject_type, subject_id} = Role.disambiguate_role(role)
      VolunteerUtils.Map.update_always(accum, subject_type, %{}, fn subject_roles ->
        Map.put(subject_roles, subject_id, role.relation)
      end)
    end)
  end

  def relations_for_subject_type(subject_type) do
    Role.relations_for_subject_type(subject_type)
  end
end
