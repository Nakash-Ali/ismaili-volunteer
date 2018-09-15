defmodule VolunteerWeb.Admin.ListingControllerTest do
  use VolunteerWeb.ConnCase
  alias Volunteer.TestFactory

  describe "new/2" do
    test "renders form", %{conn: conn} do
      {:ok, conn, _user} = create_and_login_user(conn)

      resp = get(conn, admin_listing_path(conn, :new))

      assert html_response(resp, 200) =~ "Create a New Listing"
    end
  end

  describe "create/2" do
    test "redirects to show when data is valid", %{conn: conn} do
      {:ok, conn, user} = create_and_login_user(conn)

      %{id: group_id, region_id: region_id} = TestFactory.group!()

      listing_params =
        TestFactory.Params.listing(%{
          group_id: group_id,
          region_id: region_id,
          organized_by_id: user.id,
        })
        |> Map.take([
          :position_title,
          :program_title,
          :summary_line,
          :region_id,
          :group_id,
          :organized_by_id,
          :hours_per_week,
          :program_description,
          :responsibilities,
          :qualifications,
        ])
        |> Map.merge(%{
          start_date_toggle: true,
          end_date_toggle: true,
        })

      conn = post(conn, admin_listing_path(conn, :create), listing: listing_params)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == admin_listing_path(conn, :show, id)

      conn = get(conn, admin_listing_path(conn, :show, id))
      html = html_response(conn, 200)

      [
        :position_title,
        :program_title,
        :summary_line,
        :responsibilities,
        :qualifications,
      ]
      |> Enum.map(fn key ->
        expected =
          Map.get(listing_params, key)
          |> Phoenix.HTML.html_escape()
          |> Phoenix.HTML.safe_to_string()

        assert html =~ expected
      end)

      assert html =~ "Waiting for approval"
    end
  end
end
