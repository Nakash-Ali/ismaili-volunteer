defmodule VolunteerWeb.API.RelatedHelpers do
  alias Volunteer.Accounts.User
  alias Volunteer.Infrastructure.Region
  alias Volunteer.Infrastructure.Group
  alias VolunteerWeb.Presenters.Title

  @module_mapping %{
    User => :user,
    Region => :region,
    Group => :group,
  }

  def render!(parent, related_field) do
    {related_module, related_id_field} = get_related_schema!(parent, related_field)
    related_type = get_related_type!(related_module)

    case Map.fetch(parent, related_field) do
      {:ok, %{__struct__: ^related_module} = related} ->
        render_related(
          related_type,
          related
        )

      _ ->
        render_reference(
          related_type,
          Map.fetch!(parent, related_id_field)
        )
    end
  end

  defp render_reference(type, nil) do
    nil
  end

  defp render_reference(type, id) do
    %{
      type: type,
      ref: true,
      id: id,
    }
  end

  defp render_related(:user, %User{} = user) do
    %{
      type: :user,
      id: user.id,
      title: Title.plain(user)
    }
  end

  defp render_related(:region, %Region{} = region) do
    %{
      type: :region,
      id: region.id,
      slug: region.slug,
      title: Title.plain(region),
      parent: render!(region, :parent)
    }
  end

  defp render_related(:group, %Group{} = group) do
    %{
      type: :group,
      id: group.id,
      title: Title.plain(group),
      region: render!(group, :region)
    }
  end

  defp get_related_schema!(%{__struct__: parent_module}, related_field) do
    %{related: related_module, owner_key: related_id_field} = parent_module.__schema__(:association, related_field)
    {related_module, related_id_field}
  end

  defp get_related_type!(related_module) do
    Map.fetch!(@module_mapping, related_module)
  end
end
