defmodule Volunteer.Infrastructure.HardcodedConfig do
  defmodule Utils do
    def construct_jamatkhanas(region_name, jamatkhanas) do
      Enum.map(jamatkhanas, fn jk -> "#{jk}, #{region_name}" end)
    end
  end

  @system_email_prefix "OpportunitiesToServe"

  @canada_council_website %{
    text: "iicanada.org",
    url: "https://iicanada.org"
  }
  @canada_privacy_policy %{
    text: """
          IICanada.org respects your privacy and is committed to protecting your personal information. Any personal information voluntarily submitted to IICanada.org signifies your desire to receive community‐related information and also to be contacted by the community institutions. Other than the collection, use and disclosure of your personal information to the Ismaili Institutions and its volunteers for the purposes of contacting you and/or considering you for potential volunteer positions within the community, we will not use or disclose your personal information without your express consent.
          """,
    address: [
      "His Highness Prince Aga Khan Shia Imami Ismaili Council for Canada",
      "49 Wynford Drive",
      "Toronto, Ontario M3C 1K1",
      "Canada",
      "Tel: +1 (416) 646-6965",
    ]
  }

  @config_by_region %{
    # Canada
    1 => %{
      system_email: {"#{@system_email_prefix} - Canada", "canada.ots@iicanada.net"},
      ots_website: "https://ots.the.ismaili/canada",
      council_website: @canada_council_website,
      jumbotron: %{
        image_url: "/static/images/muqarnas.png",
        spanner_bg_color: "#971421"
      },
      marketing_request: %{
        email: [],
        channels: %{}
      },
      jamatkhanas: [],
      privacy_policy: @canada_privacy_policy,
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
      council_website: @canada_council_website,
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
      jamatkhanas: Utils.construct_jamatkhanas("Ontario", [
        "Barrie",
        "Belleville",
        "Brampton",
        "Brantford",
        "Don Mills",
        "Downtown",
        "Durham",
        "East York",
        "Etobicoke",
        "Guelph",
        "Halton",
        "Hamilton",
        "Headquarters",
        "Kitchener",
        "London",
        "Meadowvale",
        "Mississauga",
        "Niagara Falls",
        "Oshawa",
        "Peterborough",
        "Pickering",
        "Richmond Hill",
        "Scarborough",
        "St. Thomas",
        "Sudbury",
        "Unionville",
        "Willowdale",
        "Windsor"
      ]),
      privacy_policy: @canada_privacy_policy,
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
      council_website: @canada_council_website,
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
      jamatkhanas: Utils.construct_jamatkhanas("BC", [
        "Burnaby Lake",
        "Chilliwack/Abbotsford",
        "Darkhana",
        "Downtown",
        "Fraser Valley",
        "Headquarters",
        "Kelowna",
        "Nanaimo",
        "Richmond",
        "Tri-City",
        "Victoria",
      ]),
      privacy_policy: @canada_privacy_policy,
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
      council_website: @canada_council_website,
      jumbotron: %{
        image_url: "/static/images/aga-khan-garden-edmonton.jpg",
        spanner_bg_color: "#971421"
      },
      marketing_request: %{
        email: [],
        channels: %{}
      },
      jamatkhanas: [],
      privacy_policy: @canada_privacy_policy,
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
      council_website: @canada_council_website,
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
      jamatkhanas: [],
      privacy_policy: @canada_privacy_policy,
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
      council_website: @canada_council_website,
      jumbotron: %{
        image_url: "/static/images/aga-khan-garden-edmonton.jpg",
        spanner_bg_color: "#971421"
      },
      marketing_request: %{
        email: ["Volunteer.prairies@iicanada.net"],
        channels: %{}
      },
      jamatkhanas: Utils.construct_jamatkhanas("Prairies", [
        "Headquarters",
        "Westwinds",
        "Northwest",
        "South",
        "Franklin"
      ]),
      privacy_policy: @canada_privacy_policy,
      tkn: %{
        country: "Canada",
        coordinator: %{
          name: "Karim Teja",
          title: "Associate Director (TKN)",
          email: "Karim.Teja@iicanada.net",
          phone: "+1 (403) 478-7867"
        }
      }
    },
    # Quebec and Maritimes
    7 => %{
      system_email: {"#{@system_email_prefix} - Quebec & Maritimes", "qm.ots@iicanada.net"},
      ots_website: "https://ots.the.ismaili/canada",
      council_website: @canada_council_website,
      jumbotron: %{
        image_url: "/static/images/global-center-for-pluralism.jpg",
        spanner_bg_color: "#971421"
      },
      marketing_request: %{
        email: [],
        channels: %{}
      },
      jamatkhanas: [],
      privacy_policy: @canada_privacy_policy,
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

  def get_region_config(region_id, key_or_keys) do
    case Map.fetch(@config_by_region, region_id) do
      {:ok, conf} ->
        fetch_config(conf, key_or_keys)

      :error ->
        {:error, "invalid region"}
    end
  end

  def aggregate_from_all_regions(key_or_keys, _opts \\ %{}) do
    result =
      @config_by_region
      |> Enum.map(fn {region_id, conf} ->
        case fetch_config(conf, key_or_keys) do
          {:ok, values} when is_list(values) ->
            {region_id, values}

          _ ->
            []
        end
      end)

    {:ok, result}
  end

  defp fetch_config(conf, key) when not is_list(key) do
    fetch_config(conf, [key])
  end

  defp fetch_config(conf, keys) when is_list(keys) do
    case VolunteerUtils.Map.fetch_in(conf, keys) do
      :error ->
        {:error, "invalid key"}

      {:ok, {module, func, args}} ->
        {:ok, apply(module, func, args)}

      {:ok, value} ->
        {:ok, value}
    end
  end
end
