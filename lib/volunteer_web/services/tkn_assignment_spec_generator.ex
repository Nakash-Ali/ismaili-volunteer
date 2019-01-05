defmodule VolunteerWeb.Services.TKNAssignmentSpecGenerator do
  alias Volunteer.Commands
  alias VolunteerWeb.Router.Helpers, as: RouterHelpers

  @disk_dir VolunteerWeb.Endpoint.static_dir(["pdfs", "tkn_assignment_specs"])

  def start_link do
    GenServer.start_link(__MODULE__.Server, nil, name: __MODULE__.Server)
  end

  def generate!(conn, listing, tkn_listing) do
    webpage_url =
      RouterHelpers.admin_listing_tkn_assignment_spec_url(conn, :show, listing)
      |> VolunteerWeb.UserSession.AuthToken.put_in_params(conn)

    GenServer.call(
      __MODULE__.Server,
      {:generate, webpage_url, @disk_dir, listing.id, listing.updated_at, tkn_listing.updated_at},
      30_000
    )
  end

  defmodule Implementation do
    def generate_pdf!(webpage_url, disk_dir, disk_path) do
      :ok = File.mkdir_p!(disk_dir)

      Commands.NodeJS.run(
        "do_webpage_pdf",
        [
          %{
            webpageUrl: webpage_url,
            outputPath: disk_path
          }
        ]
      )
    end

    def pdf_disk_path(disk_dir, listing_id, listing_updated_at, tkn_listing_updated_at) do
      Path.join([
        disk_dir,
        pdf_filename(listing_id, listing_updated_at, tkn_listing_updated_at)
      ])
    end

    def pdf_filename(listing_id, listing_updated_at, tkn_listing_updated_at) do
      filename =
        VolunteerUtils.File.consistent_hash_b64([
          listing_id,
          listing_updated_at,
          tkn_listing_updated_at
        ])

      "#{filename}.pdf"
    end
  end

  defmodule Server do
    use GenServer

    def init(_) do
      {:ok, nil}
    end

    def handle_call(
      {:generate, webpage_url, disk_dir, listing_id, listing_updated_at,
       tkn_listing_updated_at},
      _from,
      state
    ) do
      disk_path =
        Implementation.pdf_disk_path(
          disk_dir,
          listing_id,
          listing_updated_at,
          tkn_listing_updated_at
        )

      {:ok, _} =
        VolunteerUtils.File.run_func_if_not_exists(
          disk_path,
          fn -> Implementation.generate_pdf!(webpage_url, disk_dir, disk_path) end
        )

      {:reply, disk_path, state}
    end
  end
end
