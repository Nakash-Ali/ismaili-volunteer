defmodule VolunteerWeb.Services.SaveWebpage do
  alias VolunteerWeb.Router.Helpers, as: RouterHelpers

  def listing_social_image!(method, conn, listing) do
    generate!(
      method,
      %{
        webpage_url: RouterHelpers.listing_social_image_url(conn, :show, listing),
        output_scope: "social_image",
        output_format: "png",
        output_hash: VolunteerUtils.File.consistent_hash_b64([listing.id, listing.updated_at])
      }
    )
  end

  def tkn_assignment_spec!(method, conn, listing) do
    generate!(
      method,
      %{
        webpage_url: RouterHelpers.admin_listing_tkn_assignment_spec_url(conn, :show, listing) |> VolunteerWeb.UserSession.AuthToken.put_in_params(conn),
        output_scope: "tkn_assignment_spec",
        output_format: "pdf",
        output_hash: VolunteerUtils.File.consistent_hash_b64([listing.id, listing.updated_at])
      }
    )
  end

  def generate!(:sync, opts) do
    {:ok, %{"url" => url}} = Volunteer.Funcs.action!("save_webpage", opts)

    url
  end

  def generate!(:async, opts) do
    {:ok, _pid} = Task.start(fn -> generate!(:sync, opts) end)

    :ok
  end
end
