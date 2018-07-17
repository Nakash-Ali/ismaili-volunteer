defmodule VolunteerWeb.Services.ListingSocialImageGenerator do
  use GenServer
  alias Volunteer.Commands
  alias VolunteerWeb.Router.Helpers
  
  def static_at do
    Application.get_env(:volunteer, VolunteerWeb.Endpoint) |> Keyword.fetch!(:static_at)
  end
  
  def static_dir do
    Path.join(["images", "listing"])
  end
  
  def disk_dir() do
    Path.join([:code.priv_dir(:volunteer), static_at(), static_dir()])
  end
  
  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end
  
  def get(conn, listing) do
    webpage_url = Helpers.listing_listing_social_image_url(conn, :show, listing)
    GenServer.call(__MODULE__, {:get, webpage_url, listing.id, listing.updated_at}, 30_000)
  end
  
  def init(:ok) do
    {:ok, %{}}
  end
  
  def handle_call({:get, webpage_url, listing_id, listing_updated_at}, _from, state) do
    disk_path = image_disk_path(listing_id, listing_updated_at)
    {:ok, _} =
      case File.stat(disk_path) do
        {:ok, %File.Stat{type: :regular}} ->
          {:ok, :exists}
        _ ->
          generate_image!(webpage_url, disk_path)
      end
    {:reply, disk_path, state}
  end
  
  def image_disk_path(listing_id, listing_updated_at) do
    image_filename(listing_id, listing_updated_at)
    |> image_disk_path()
  end
  
  def image_disk_path(filename) do
    Path.join([disk_dir(), filename])
  end
  
  def image_filename(listing_id, listing_updated_at) do
    hashed_listing_str =
      :sha
      |> :crypto.hash("#{listing_id}#{listing_updated_at}")
      |> Base.hex_encode32(case: :lower, padding: false)
    "#{hashed_listing_str}.png"
  end
  
  def image_url(conn, listing) do
    Helpers.listing_social_image_path(conn, :image, listing)
  end
  
  def generate_config(webpage_url, disk_path) do
    [
      %{
        webpageUrl: webpage_url,
        outputPath: disk_path
      }
    ]
  end
  
  def generate_image!(webpage_url, disk_path) do
    :ok = File.mkdir_p!(disk_dir())
    Commands.run("do_webpage_screenshot", generate_config(webpage_url, disk_path))
  end
end
