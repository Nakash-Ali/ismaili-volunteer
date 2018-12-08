defmodule Volunteer.Infrastructure.HardcodedConfig do
  @config_by_region %{
    # Canada
    1 => %{
      website_url: "https://iicanada.org/serveontario",
      system_email: {"OpportunitiesToServe", "hrontario@iicanada.net"},
      jumbotron_image_url: "/static/images/aga-khan-garden-edmonton.jpg",
      marketing_request_email: [],
      marketing_channels: %{
        "Al-Akhbar" => "text"
      },
      tkn_country: "Canada",
      tkn_coordinator: %{
        name: "",
        title: "",
        email: "",
        phone: "",
      }
    },
    # Ontario
    2 => %{
      website_url: "https://iicanada.org/serveontario",
      system_email: {"OpportunitiesToServe", "hrontario@iicanada.net"},
      jumbotron_image_url: "/static/images/ismaili-center-toronto.jpg",
      marketing_request_email: ["cfo-announcements@iicanada.net"],
      marketing_channels: %{
        "Al-Akhbar" => "text",
        "IICanada App & Website" => "text",
        "JK announcement" => "text"
      },
      tkn_country: "Canada",
      tkn_coordinator: %{
        name: "",
        title: "",
        email: "",
        phone: "",
      }
    }
  }

  @default_config @config_by_region[1]

  def get_region_config(region_id, key) do
    conf = Map.get(@config_by_region, region_id, @default_config)

    if Map.has_key?(conf, key) do
      {:ok, Map.fetch!(conf, key)}
    else
      {:error, "invalid key"}
    end
  end
end
