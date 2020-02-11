defmodule VolunteerWeb.Admin.RoleController do
  use VolunteerWeb, :controller
  alias Volunteer.Roles
  alias VolunteerWeb.UserSession
  alias VolunteerWeb.FlashHelpers
  alias VolunteerWeb.ConnPermissions
  import VolunteerWeb.NoRouteErrorController, only: [raise_error: 2]

  # Plugs

  plug :load_subject_config
  plug :load_subject
  plug :authorize
  plug :track

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

  def authorize(conn, _opts) do
    %{assigns: %{subject_config: %{subject_type: subject_type}}} = conn

    ConnPermissions.authorize(
      conn,
      action_root: [:admin, subject_type, :role],
      assigns_subject_key: :subject
    )
  end

  def track(%Plug.Conn{assigns: %{subject_config: %{subject_type: subject_type}}} = conn, _opts) do
    VolunteerWeb.Services.Analytics.Plugs.track(
      conn,
      resource: subject_type,
      assigns_subject_key: :subject
    )
  end

  # Controller Actions

  def index(conn, _params) do
    %{assigns: %{subject: subject, subject_config: subject_config}} = conn

    roles = Roles.get_subject_roles(subject_config.subject_type, subject_config.subject_id)

    render(conn, "index.html", [subject: subject, roles: roles] ++ Enum.into(subject_config, []))
  end

  def new(conn, _params) do
    %{assigns: %{subject: subject, subject_config: subject_config}} = conn

    changeset = Roles.new(subject_config.subject_type, subject_config.subject_id)

    render_form(conn, subject_config, changeset, subject: subject)
  end

  def create(conn, params) do
    %{assigns: %{subject: subject, subject_config: subject_config}} = conn

    Roles.create(
      subject_config.subject_type,
      subject_config.subject_id,
      params["role"],
      UserSession.get_user(conn)
    )
    |> case do
      {:ok, _result} ->
        conn
        |> FlashHelpers.put_paragraph_flash(:success, "Role created successfully.")
        |> redirect(to: subject_config.router_helper.(conn, :index, subject_config.subject_id))

      {:error, :create, %Ecto.Changeset{} = %{errors: [_exclusive_arc: _]} = _changeset, _prev} ->
        raise "Something's gone terribly wrong!"

      {:error, :create, %Ecto.Changeset{} = %{errors: [_unique_relation: _]} = changeset, _prev} ->
        conn
        |> FlashHelpers.put_paragraph_flash(:error, "This user has already been assigned a role for this #{subject_config.subject_type}. Please delete that first before creating a new one")
        |> render_form(subject_config, changeset, subject: subject)

      {:error, :create, changeset, _prev} ->
        conn
        |> FlashHelpers.put_paragraph_flash(:error, "Oops, something went wrong! Please check the errors below.")
        |> render_form(subject_config, changeset, subject: subject)
    end
  end

  def delete(conn, params) do
    %{assigns: %{subject_config: subject_config}} = conn

    {:ok, _} =
      Roles.delete(
        subject_config.subject_type,
        subject_config.subject_id,
        params["id"],
        UserSession.get_user(conn)
      )

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
        user_id_choices: Volunteer.Accounts.get_all_admin_users() |> VolunteerUtils.Choices.make(%{blank: true}),
        relation_choices: Roles.relations_for_subject_type(subject_config.subject_type) |> VolunteerUtils.Choices.make(%{blank: true}),
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
