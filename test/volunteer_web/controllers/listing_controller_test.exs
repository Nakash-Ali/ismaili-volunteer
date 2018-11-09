defmodule VolunteerWeb.ListingControllerTest do
  use VolunteerWeb.ConnCase
  alias Volunteer.TestSupport.Factory

  describe "index/2" do
    test "renders all valid listings", %{conn: conn} do
      should_appear =
        [
          Factory.listing!(%{approved?: true, expired?: false}),
        ]

      should_not_appear =
        [
          Factory.listing!(%{approved?: false, expired?: false}),
          Factory.listing!(%{approved?: false, expired?: true}),
          Factory.listing!(%{approved?: true, expired?: true}),
        ]

      conn = get(conn, index_path(conn, :index))
      html = html_response(conn, 200)

      listing_html = fn(li) -> VolunteerWeb.Presenters.Title.html(li) |> Phoenix.HTML.safe_to_string() end

      assert html =~ "Volunteer Opportunities"

      Enum.map(should_appear, fn li -> assert html =~ listing_html.(li) end)
      Enum.map(should_not_appear, fn li -> refute html =~ listing_html.(li) end)
    end
  end
end
