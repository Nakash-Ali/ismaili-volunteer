defmodule VolunteerWeb.Services.ListingSocialImageGenerator do
  alias Volunteer.Commands
  alias VolunteerWeb.Router.Helpers, as: RouterHelpers

  @disk_dir VolunteerWeb.Endpoint.static_dir(["images", "listing"])

  def start_link do
    GenServer.start_link(__MODULE__.Server, nil, name: __MODULE__.Server)
  end

  def generate!(conn, listing) do
    webpage_url = RouterHelpers.listing_social_image_url(conn, :show, listing)

    GenServer.call(
      __MODULE__.Server,
      {:generate, webpage_url, @disk_dir, listing.id, listing.updated_at},
      30_000
    )
  end

  defmodule Implementation do
    def generate_image!(webpage_url, disk_dir, disk_path) do
      :ok = File.mkdir_p!(disk_dir)

      Commands.NodeJS.run(
        "do_webpage_screenshot",
        [
          %{
            webpageUrl: webpage_url,
            outputPath: disk_path
          }
        ]
      )
    end

    def image_disk_path(disk_dir, listing_id, listing_updated_at) do
      Path.join([
        disk_dir,
        image_filename(listing_id, listing_updated_at)
      ])
    end

    def image_filename(listing_id, listing_updated_at) do
      filename =
        VolunteerUtils.File.consistent_hash_b64([
          listing_id,
          listing_updated_at
        ])

      "#{filename}.png"
    end
  end

  defmodule Server do
    use GenServer

    def init(_) do
      {:ok, nil}
    end

    def handle_call(
      {:generate, webpage_url, disk_dir, listing_id, listing_updated_at},
      _from,
      state
    ) do
      disk_path = Implementation.image_disk_path(disk_dir, listing_id, listing_updated_at)

      {:ok, _} =
        VolunteerUtils.File.run_func_if_not_exists(
          disk_path,
          fn -> Implementation.generate_image!(webpage_url, disk_dir, disk_path) end
        )

      {:reply, disk_path, state}
    end
  end
end
