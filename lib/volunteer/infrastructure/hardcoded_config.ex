defmodule Volunteer.Infrastructure.HardcodedConfig do
  @config_by_region %{
    # Canada
    1 => %{
      system_email: {"OpportunitiesToServe", "hrontario@iicanada.net"},
      ots_website: "https://iicanada.org/serveontario",
      council_website: %{
        text: "the.ismaili/canada",
        url: "https://the.ismaili/canada"
      },
      jumbotron: %{
        image_url: "/static/images/aga-khan-garden-edmonton.jpg",
        spanner_bg_color: "#971421",
      },
      marketing_request: %{
        email: [],
        channels: %{
          "Al-Akhbar" => "text"
        }
      },
      tkn: %{
        country: "Canada",
        coordinator: %{
          name: "",
          title: "",
          email: "",
          phone: "",
        }
      }
    },
    # Ontario
    2 => %{
      system_email: {"OpportunitiesToServe", "hrontario@iicanada.net"},
      ots_website: "https://iicanada.org/serveontario",
      council_website: %{
        text: "the.ismaili/canada",
        url: "https://the.ismaili/canada"
      },
      jumbotron: %{
        image_url: "/static/images/ismaili-center-toronto.jpg",
        spanner_bg_color: "#971421",
      },
      marketing_request: %{
        email: ["cfo-announcements@iicanada.net"],
        channels: %{
          "Al-Akhbar" => "text",
          "IICanada App & Website" => "text",
          "JK announcement" => "text"
        }
      },
      tkn: %{
        country: "Canada",
        coordinator: %{
          name: "",
          title: "",
          email: "",
          phone: "",
        }
      }
    }
  }

  @default_region_id 1
  @default_config @config_by_region[@default_region_id]

  def get_region_config(region_id, key) when is_atom(key) do
    get_region_config(region_id, [key])
  end

  def get_region_config(region_id, keys) when is_list(keys) do
    conf = Map.get(@config_by_region, region_id, @default_config)

    case Kernel.get_in(conf, keys) do
      nil ->
        {:error, "invalid key"}

      value ->
        {:ok, value}
    end
  end
end
