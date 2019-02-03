defmodule Volunteer.Infrastructure.HardcodedConfig do
  @system_email_prefix "OpportunitiesToServe"
  @config_by_region %{
    # Canada
    1 => %{
      system_email: {"#{@system_email_prefix} - Canada", "canada.ots@iicanada.net"},
      ots_website: "https://ots.the.ismaili/canada",
      council_website: %{
        text: "iicanada.org",
        url: "https://iicanada.org"
      },
      jumbotron: %{
        image_url: "/static/images/muqarnas.png",
        spanner_bg_color: "#971421"
      },
      marketing_request: %{
        email: [],
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
          phone: ""
        }
      }
    },
    # Ontario
    2 => %{
      system_email: {"#{@system_email_prefix} - Ontario", "ontario.ots@iicanada.net"},
      ots_website: "https://ots.the.ismaili/canada",
      council_website: %{
        text: "iicanada.org",
        url: "https://iicanada.org"
      },
      jumbotron: %{
        image_url: "/static/images/ismaili-center-toronto.jpg",
        spanner_bg_color: "#971421"
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
          phone: ""
        }
      }
    },
    # British Columbia
    3 => %{
      system_email: {"#{@system_email_prefix} - British Columbia", "bc.ots@iicanada.net"},
      ots_website: "https://ots.the.ismaili/canada",
      council_website: %{
        text: "iicanada.org",
        url: "https://iicanada.org"
      },
      jumbotron: %{
        image_url: "/static/images/ismaili-center-burnaby-2.jpg",
        spanner_bg_color: "#971421"
      },
      marketing_request: %{
        email: ["farah.surani@iicanada.net"],
        channels: %{
          "Al-Akhbar" => "text",
          "IICanada App & Website" => "text",
          "JK announcement" => "text"
        }
      },
      tkn: %{
        country: "Canada",
        coordinator: %{
          name: "Sultana Mithani",
          title: "Associate Director (TKN)",
          email: "sultana.mithani@iicanada.net",
          phone: "+1 (604) 376-8818"
        }
      }
    },
    # Edmonton
    4 => %{
      system_email: {"#{@system_email_prefix} - Edmonton", "edmonton.ots@iicanada.net"},
      ots_website: "https://ots.the.ismaili/canada",
      council_website: %{
        text: "iicanada.org",
        url: "https://iicanada.org"
      },
      jumbotron: %{
        image_url: "/static/images/aga-khan-garden-edmonton.jpg",
        spanner_bg_color: "#971421"
      },
      marketing_request: %{
        email: [],
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
          phone: ""
        }
      }
    },
    # Ottawa
    5 => %{
      system_email: {"#{@system_email_prefix} - Ottawa", "ottawa.ots@iicanada.net"},
      ots_website: "https://ots.the.ismaili/canada",
      council_website: %{
        text: "iicanada.org",
        url: "https://iicanada.org"
      },
      jumbotron: %{
        image_url: "/static/images/delegation-of-the-ismaili-imamat.jpg",
        spanner_bg_color: "#971421"
      },
      marketing_request: %{
        email: ["jahangir.valliani@iicanada.net"],
        channels: %{
          "Al-Akhbar" => "text",
          "IICanada App & Website" => "text",
          "JK announcement" => "text"
        }
      },
      tkn: %{
        country: "Canada",
        coordinator: %{
          name: "Farhan Bhayani",
          title: "Associate Director (TKN)",
          email: "farhan.bhayani@iicanada.net",
          phone: ""
        }
      }
    },
    # Prairies
    6 => %{
      system_email: {"#{@system_email_prefix} - Prairies", "prairies.ots@iicanada.net"},
      ots_website: "https://ots.the.ismaili/canada",
      council_website: %{
        text: "iicanada.org",
        url: "https://iicanada.org"
      },
      jumbotron: %{
        image_url: "/static/images/aga-khan-garden-edmonton.jpg",
        spanner_bg_color: "#971421"
      },
      marketing_request: %{
        email: [],
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
          phone: ""
        }
      }
    },
    # Quebec and Maritimes
    7 => %{
      system_email: {"#{@system_email_prefix} - Quebec & Maritimes", "qm.ots@iicanada.net"},
      ots_website: "https://ots.the.ismaili/canada",
      council_website: %{
        text: "iicanada.org",
        url: "https://iicanada.org"
      },
      jumbotron: %{
        image_url: "/static/images/global-center-for-pluralism.jpg",
        spanner_bg_color: "#971421"
      },
      marketing_request: %{
        email: [],
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
          phone: ""
        }
      }
    }
  }

  def get_region_config!(region_id) do
    Map.fetch!(@config_by_region, region_id)
  end

  def get_region_config(region_id, key) when not is_list(key) do
    get_region_config(region_id, [key])
  end

  def get_region_config(region_id, keys) when is_list(keys) do
    case Map.fetch(@config_by_region, region_id) do
      {:ok, conf} ->
        case fetch_in(conf, keys) do
          :error ->
            {:error, "invalid key"}

          {:ok, value} ->
            {:ok, value}
        end

      :error ->
        {:error, "invalid region"}
    end
  end

  defp fetch_in(value, []) do
    {:ok, value}
  end

  defp fetch_in(map, [key | tail]) when is_map(map) do
    case Map.fetch(map, key) do
      {:ok, value} ->
        fetch_in(value, tail)

      :error ->
        :error
    end
  end
end
