defmodule VolunteerWeb.Admin.SystemController do
  use VolunteerWeb, :controller
  import VolunteerWeb.ConnPermissions, only: [authorize: 2]

  # Plugs

  plug :authorize, action_root: [:admin, :system]

  # Actions

  # def feedback_from_organizers(conn, _params) do
  #   import Ecto.Query
  #   import Phoenix.HTML, only: [sigil_E: 2]
  #
  #   listings =
  #     from(
  #       l in Volunteer.Listings.Listing,
  #       join: a in subquery(
  #         from(a in Volunteer.Apply.Applicant, distinct: true, select: a.listing_id)
  #       ),
  #       on: l.id == a.listing_id
  #     )
  #     |> Volunteer.Repo.all
  #     |> Volunteer.Repo.preload([:created_by, :organized_by])
  #
  #   _emails =
  #     Enum.map(listings, fn listing ->
  #       assigns = %{
  #         link: URI.encode("https://docs.google.com/forms/d/e/1FAIpQLSdbQTNkrWSIp4PuFebXO5Zi3Ia-GbEbweGLrtjA7AUANGjZQQ/viewform?usp=pp_url&entry.1626591742=#{listing.id}&entry.374021322=#{VolunteerWeb.Presenters.Title.plain(listing)}")
  #       }
  #
  #       listing.region_id
  #       |> VolunteerEmail.Mailer.new_default_email()
  #       |> VolunteerEmail.Tools.append(:to, VolunteerEmail.ListingsEmails.generate_primary_address_list(listing))
  #       |> Map.put(:subject, VolunteerEmail.ListingsEmails.generate_subject("Feedback", listing))
  #       |> Map.put(:html_body, Phoenix.View.render_to_string(
  #         VolunteerEmail.LayoutView,
  #         "email.html",
  #         do: ~E"""
  #             <p>Ya Ali Madad,</p>
  #
  #             <p>We would like your feedback on OTS for this particular listing. Your feedback will be anonymous and is invaluable to us, we hope you will share openly and honestly. It should only take a couple minutes, <strong>click on the link below:</strong></p>
  #
  #             <p><a target="_blank" href="<%= @link %>"><%= @link %></a></p>
  #
  #             <p>Thank you so much!</p>
  #
  #             <p>Best Regards,<br>
  #             <%= Application.fetch_env!(:volunteer, :global_title) %></p>
  #             """,
  #         disclaimers: Volunteer.Infrastructure.get_region_config!(listing.region_id, [:disclaimers])
  #       ))
  #       |> VolunteerEmail.Mailer.deliver_now!
  #     end)
  #
  #   conn
  #   |> VolunteerWeb.FlashHelpers.put_paragraph_flash(:info, "Successfully sent for #{length(listings)} listings")
  #   |> redirect(to: RouterHelpers.admin_system_path(conn, :index))
  # end

  def env(conn, _params) do
    render(
      conn,
      "data.html",
      data: System.get_env()
    )
  end

  def app(conn, _params) do
    render(
      conn,
      "data.html",
      data: :application.loaded_applications()
            |> Enum.map(fn {app, _description, _version} ->
              {app, :application.get_all_env(app)}
            end)
            |> Enum.into(%{})
    )
  end

  def endpoint(conn, _params) do
    render(
      conn,
      "data.html",
      data: :ets.tab2list(VolunteerWeb.Endpoint)
    )
  end

  def req_headers(conn, _params) do
    render(
      conn,
      "data.html",
      data: conn.req_headers
    )
  end

  def spoof(conn, %{"user_id" => user_id}) do
    user = Volunteer.Accounts.get_user!(user_id)

    conn
    |> VolunteerWeb.UserSession.login(user)
    |> VolunteerWeb.FlashHelpers.put_paragraph_flash(:info, "Successfully authenticated as #{VolunteerWeb.Presenters.Title.plain(user)}")
    |> redirect(to: RouterHelpers.admin_index_path(conn, :index))
  end
end
