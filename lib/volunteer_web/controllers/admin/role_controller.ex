defmodule VolunteerWeb.Admin.RoleController do
  use VolunteerWeb, :controller
  alias Volunteer.Roles
  alias VolunteerWeb.ConnPermissions
  alias VolunteerWeb.FlashHelpers
  import VolunteerWeb.NoRouteErrorController, only: [raise_error: 2]

  # Plugs

  plug :load_subject_config
  plug :load_subject

  def load_subject_config(%Plug.Conn{params: params} = conn, _opts) do
    case subject_config_from_params(params) do
      nil ->
        raise_error(conn, [])

      subject_config when is_map(subject_config) ->
        Plug.Conn.assign(conn, :subject_config, subject_config)
    end
  end

  def load_subject(%Plug.Conn{assigns: %{subject_config: subject_config}} = conn, _opts) do
    %{subject_type: subject_type, subject_id: subject_id} = subject_config

    Plug.Conn.assign(
      conn,
      :subject,
      Roles.get_subject!(subject_type, subject_id)
    )
  end

  # Controller Actions

  def index(conn, _params) do
    %{assigns: %{subject: subject, subject_config: subject_config}} = conn

    conn = ConnPermissions.ensure_allowed!(conn, [:admin, subject_config.subject_type, :role, :index], subject)

    roles = Roles.get_subject_roles(subject_config.subject_type, subject_config.subject_id)

    render(conn, "index.html", [subject: subject, roles: roles] ++ Enum.into(subject_config, []))
  end

  def new(conn, _params) do
    %{assigns: %{subject: subject, subject_config: subject_config}} = conn

    conn = ConnPermissions.ensure_allowed!(conn, [:admin, subject_config.subject_type, :role, :create], subject)

    changeset = Roles.new_subject_role(subject_config.subject_type, subject_config.subject_id)

    render_form(conn, subject_config, changeset, subject: subject)
  end

  def create(conn, params) do
    %{assigns: %{subject: subject, subject_config: subject_config}} = conn

    conn = ConnPermissions.ensure_allowed!(conn, [:admin, subject_config.subject_type, :role, :create], subject)

    Roles.create_subject_role(
      subject_config.subject_type,
      subject_config.subject_id,
      params["role"]
    )
    |> case do
      {:ok, _roles} ->
        # TODO: Implement email notifications when a role is created!

        conn
        |> FlashHelpers.put_paragraph_flash(:success, "Role created successfully.")
        |> redirect(to: subject_config.router_helper.(conn, :index, subject_config.subject_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        case VolunteerWeb.ErrorHelpers.get_underscore_errors(changeset) do
          [] ->
            conn
            |> FlashHelpers.put_paragraph_flash(:error, "Oops, something went wrong! Please check the errors below.")
            |> render_form(subject_config, changeset, subject: subject)

          errors ->
            conn
            |> FlashHelpers.put_underscore_errors(errors)
            |> render_form(subject_config, changeset, subject: subject, underscore_errors: errors)
        end
    end
  end

  def delete(conn, params) do
    %{assigns: %{subject: subject, subject_config: subject_config}} = conn

    conn = ConnPermissions.ensure_allowed!(conn, [:admin, subject_config.subject_type, :role, :delete], subject)

    Roles.delete_subject_role!(subject_config.subject_type, subject_config.subject_id, params["id"])

    # TODO: Implement email notifications when a role is deleted!

    conn
    |> FlashHelpers.put_paragraph_flash(:success, "Role deleted successfully.")
    |> redirect(to: subject_config.router_helper.(conn, :index, subject_config.subject_id))
  end

  def render_form(conn, subject_config, changeset, opts \\ []) do
    render(
      conn,
      "new.html",
      [
        changeset: changeset,
        action_path: subject_config.router_helper.(conn, :create, subject_config.subject_id),
        back_path: subject_config.router_helper.(conn, :index, subject_config.subject_id),
        user_id_choices: VolunteerUtils.Controller.blank_select_choice() ++ Volunteer.Accounts.get_admin_user_id_choices(),
        relation_choices: VolunteerUtils.Controller.blank_select_choice() ++ Roles.choices_for_relations(subject_config.subject_type)
      ] ++ Enum.into(subject_config, []) ++ opts
    )
  end

  def subject_config_from_params(%{"group_id" => group_id}) do
    %{
      subject_type: :group,
      subject_id: group_id,
      router_helper: &RouterHelpers.admin_group_role_path/3,
      router_module: RouterHelpers,
      router_func: :admin_group_role_path
    }
  end

  def subject_config_from_params(%{"region_id" => region_id}) do
    %{
      subject_type: :region,
      subject_id: region_id,
      router_helper: &RouterHelpers.admin_region_role_path/3,
      router_module: RouterHelpers,
      router_func: :admin_region_role_path
    }
  end

  def subject_config_from_params(%{"listing_id" => listing_id}) do
    %{
      subject_type: :listing,
      subject_id: listing_id,
      router_helper: &RouterHelpers.admin_listing_role_path/3,
      router_module: RouterHelpers,
      router_func: :admin_listing_role_path
    }
  end

  def subject_config_from_params(_params) do
    nil
  end
end
