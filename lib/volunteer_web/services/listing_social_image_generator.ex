defmodule VolunteerWeb.Services.ListingSocialImageGenerator do
  alias Volunteer.Funcs
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

  def generate_async(conn, listing) do
    webpage_url = RouterHelpers.listing_social_image_url(conn, :show, listing)

    GenServer.cast(
      __MODULE__.Server,
      {:generate, webpage_url, @disk_dir, listing.id, listing.updated_at}
    )
  end

  defmodule Implementation do
    def maybe_generate_image!(webpage_url, disk_dir, listing_id, listing_updated_at) do
      disk_path = Implementation.image_disk_path(disk_dir, listing_id, listing_updated_at)

      {:ok, _} =
        VolunteerUtils.File.run_func_if_not_exists(
          disk_path,
          fn -> Implementation.generate_image!(webpage_url, disk_dir, disk_path) end
        )

      disk_path
    end

    def generate_image!(webpage_url, disk_dir, disk_path) do
      {:ok, screenshot_data} = Funcs.run!("webpage_screenshot", %{webpageUrl: webpage_url})

      :ok = File.mkdir_p!(disk_dir)
      :ok = File.write!(disk_path, screenshot_data, [:sync])

      {:ok, screenshot_data}
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
      disk_path =
        Implementation.maybe_generate_image!(webpage_url, disk_dir, listing_id, listing_updated_at)

      {:reply, disk_path, state}
    end

    def handle_cast(
      {:generate, webpage_url, disk_dir, listing_id, listing_updated_at},
      state
    ) do
      _disk_path =
        Implementation.maybe_generate_image!(webpage_url, disk_dir, listing_id, listing_updated_at)

      {:noreply, state}
    end
  end
end
