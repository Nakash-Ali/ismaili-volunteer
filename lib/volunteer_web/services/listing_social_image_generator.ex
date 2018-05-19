defmodule VolunteerWeb.Services.ListingSocialImageGenerator do
  alias Volunteer.Commands
  alias VolunteerWeb.Router.Helpers
  
  @static_at Application.get_env(:volunteer, VolunteerWeb.Endpoint) |> Keyword.fetch!(:static_at)
  @static_path Path.join(["images", "listing"])
  @static_output Path.join([:code.priv_dir(:volunteer), @static_at, @static_path])
  
  def file_name(listing) do
    hashed_listing_str =
      :sha
      |> :crypto.hash("#{listing.id}#{listing.updated_at}")
      |> Base.hex_encode32(case: :lower, padding: false)
    "#{hashed_listing_str}.png"
  end
  
  def static_url(conn, listing) do
    Helpers.static_url(conn, "/" <> Path.join([@static_path, file_name(listing)]))
  end
  
  def output_path(listing) do
    Path.join([@static_output, file_name(listing)])
  end
  
  def generate_config(conn, listing) do
    [
      %{
        webpageUrl: Helpers.listing_listing_social_image_url(conn, :show, listing),
        outputPath: output_path(listing)
      }
    ]
  end
  
  def generate_image!(conn, listing) do
    :ok = File.mkdir_p!(@static_output)
    {:ok, output} = Commands.run("do_webpage_screenshot", generate_config(conn, listing))
  end
  
  def generate_image_async(conn, listing) do
    Task.async(fn -> generate_image!(conn, listing) end)
  end
end
