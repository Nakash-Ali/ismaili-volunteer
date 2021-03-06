defmodule VolunteerHardcoded.Regions do
  use VolunteerHardcoded
  import Phoenix.HTML, only: [sigil_E: 2]

  @global_url Application.get_env(:volunteer, :global_url)
  @system_email_prefix Application.get_env(:volunteer, :global_title)

  @canada_council_website %{
    text: "iicanada.org",
    url: "https://iicanada.org"
  }

  @canada_disclaimers %{
    apply_privacy_text:
      ~E"""
      <%= Application.get_env(:volunteer, :global_title) %> respects your privacy and is committed to protecting your personal information. Any personal information voluntarily submitted to <%= Application.get_env(:volunteer, :global_title) %> signifies your desire to receive community‐related information and also to be contacted by the community institutions. Other than the collection, use and disclosure of your personal information to the Ismaili Institutions and its volunteers for the purposes of contacting you and/or considering you for potential volunteer positions within the community, we will not use or disclose your personal information without your express consent.
      """,
    email_privacy_text:
      ~E"""
      This email is sent by His Highness Prince Aga Khan Shia Imami Ismaili Council for Canada (the "Aga Khan Council for Canada"). You are receiving this email because you signed up through the <%= Application.get_env(:volunteer, :global_title) %> website.
      """,
    email_unsubscribe_text:
      ~E"""
      To unsubscribe from future communication from the <%= Application.get_env(:volunteer, :global_title) %> website, please email <%= Application.get_env(:volunteer, :global_email) |> VolunteerWeb.HTMLHelpers.external_link(:mailto) %>.
      """,
    address: [
      "His Highness Prince Aga Khan Shia Imami Ismaili Council for Canada",
      "The Ismaili Centre",
      "49 Wynford Drive",
      "Toronto, Ontario M3C 1K1",
      "Canada",
      ~E"Tel: <%= VolunteerWeb.HTMLHelpers.external_link(\"+1 (416) 646-6965\", :tel) %>",
      ~E"<%= VolunteerWeb.HTMLHelpers.external_link(\"https://iicanada.org\") %>",
    ]
  }

  @canada_marketing_channels %{
    "Al-Akhbar" => "text",
    "IICanada app & website" => "text",
    "JK announcement" => "text",
    "Social media" => "image",
  }

  @raw_config [
    {1, %{
      title: "Canada",
      slug: nil,
      parent_id: nil,
      system_email: {"#{@system_email_prefix} - Canada", "canada.ots@iicanada.net"},
      ots_website: Path.join([@global_url, "/canada"]),
      council_website: @canada_council_website,
      jumbotron: %{
        image_url: "/static/images/muqarnas.png",
        spanner_bg_color: "#971421"
      },
      marketing_request: %{
        strategy: :delegate_to_child_regions,
      },
      region_in_path: %{
        true => "all national and regional listings",
        false => "national listings only"
      },
      jamatkhanas: [],
      disclaimers: @canada_disclaimers,
      tkn: %{
        country: "Canada",
        coordinator: %{
          name: "Zabin Jadavji",
          title: "",
          email: "zabin.jadavji@iicanada.net",
          phone: "+1 (403) 968-4853"
        }
      }
    }},
    {2, %{
      title: "Ontario",
      slug: nil,
      parent_id: 1,
      system_email: {"#{@system_email_prefix} - Ontario", "ontario.ots@iicanada.net"},
      ots_website: Path.join([@global_url, "/canada"]),
      council_website: @canada_council_website,
      jumbotron: %{
        image_url: "/static/images/ismaili-center-toronto.jpg",
        spanner_bg_color: "#971421"
      },
      marketing_request: %{
        strategy: :direct,
        email: ["cfo-announcements@iicanada.net"],
        # NOTE: Do not change this. We can't properly validate requests
        # when regions have different channels available. This is a temporary
        # edge-case that will be corrected later.
        channels: @canada_marketing_channels,
      },
      jamatkhanas: VolunteerHardcoded.construct_jamatkhanas("Ontario", [
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
        "Windsor",
      ]),
      disclaimers: @canada_disclaimers,
      tkn: %{
        country: "Canada",
        coordinator: %{
          name: "Ayaz Kassam",
          title: "Associate Director, TKN",
          email: "ayaz.kassam@iicanada.net",
          phone: "+1 (647) 271-4107"
        }
      }
    }},
    {3, %{
      title: "British Columbia",
      slug: "bc",
      parent_id: 1,
      system_email: {"#{@system_email_prefix} - British Columbia", "bc.ots@iicanada.net"},
      ots_website: Path.join([@global_url, "/canada"]),
      council_website: @canada_council_website,
      jumbotron: %{
        image_url: "/static/images/ismaili-center-burnaby-2.jpg",
        spanner_bg_color: "#971421"
      },
      marketing_request: %{
        strategy: :direct,
        email: ["anita.dharsi-haji@iicanada.net"],
        # NOTE: Do not change this. We can't properly validate requests
        # when regions have different channels available. This is a temporary
        # edge-case that will be corrected later.
        channels: @canada_marketing_channels,
      },
      jamatkhanas: VolunteerHardcoded.construct_jamatkhanas("BC", [
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
      disclaimers: @canada_disclaimers,
      tkn: %{
        country: "Canada",
        coordinator: %{
          name: "Shahin Najak",
          title: "Associate Director, TKN",
          email: "shahin.najak@iicanada.net",
          phone: "+1 (778) 999-6457"
        }
      }
    }},
    {4, %{
      title: "Edmonton",
      slug: nil,
      parent_id: 1,
      system_email: {"#{@system_email_prefix} - Edmonton", "edmonton.ots@iicanada.net"},
      ots_website: Path.join([@global_url, "/canada"]),
      council_website: @canada_council_website,
      jumbotron: %{
        image_url: "/static/images/aga-khan-garden-edmonton.jpg",
        spanner_bg_color: "#971421"
      },
      marketing_request: %{
        strategy: :direct,
        email: ["jamil.ramji@gmail.com"],
        # NOTE: Do not change this. We can't properly validate requests
        # when regions have different channels available. This is a temporary
        # edge-case that will be corrected later.
        channels: @canada_marketing_channels,
      },
      jamatkhanas: VolunteerHardcoded.construct_jamatkhanas("Edmonton", [
        "Fort McMurray",
        "North",
        "Red Deer",
        "South",
        "West",
      ]),
      disclaimers: @canada_disclaimers,
      tkn: %{
        country: "Canada",
        coordinator: %{
          name: "Asmita Manji",
          title: "Associate Director, TKN",
          email: "asmita.manji@iicanada.net",
          phone: "+1 (780) 660-5786"
        }
      }
    }},
    {5, %{
      title: "Ottawa",
      slug: nil,
      parent_id: 1,
      system_email: {"#{@system_email_prefix} - Ottawa", "ottawa.ots@iicanada.net"},
      ots_website: Path.join([@global_url, "/canada"]),
      council_website: @canada_council_website,
      jumbotron: %{
        image_url: "/static/images/delegation-of-the-ismaili-imamat.jpg",
        spanner_bg_color: "#971421"
      },
      marketing_request: %{
        strategy: :direct,
        email: ["ali.tejpar@iicanada.net"],
        # NOTE: Do not change this. We can't properly validate requests
        # when regions have different channels available. This is a temporary
        # edge-case that will be corrected later.
        channels: @canada_marketing_channels,
      },
      jamatkhanas: [
        "Headquarters",
        "Kingston",
      ],
      disclaimers: @canada_disclaimers,
      tkn: %{
        country: "Canada",
        coordinator: %{
          name: "Rahim Maknojia",
          title: "Associate Director, TKN",
          email: "rahim.maknojia@iicanada.net",
          phone: "+1 (343) 987-8300"
        }
      }
    }},
    {6, %{
      title: "Prairies",
      slug: nil,
      parent_id: 1,
      system_email: {"#{@system_email_prefix} - Prairies", "prairies.ots@iicanada.net"},
      ots_website: Path.join([@global_url, "/canada"]),
      council_website: @canada_council_website,
      jumbotron: %{
        image_url: "/static/images/prairies-float.jpeg",
        spanner_bg_color: "#971421"
      },
      marketing_request: %{
        strategy: :direct,
        email: ["volunteer.prairies@iicanada.net"],
        # NOTE: Do not change this. We can't properly validate requests
        # when regions have different channels available. This is a temporary
        # edge-case that will be corrected later.
        channels: @canada_marketing_channels,
      },
      jamatkhanas: VolunteerHardcoded.construct_jamatkhanas("Prairies", [
        "Franklin",
        "Headquarters",
        "Northwest",
        "South",
        "Westwinds",
      ]),
      disclaimers: @canada_disclaimers,
      tkn: %{
        country: "Canada",
        coordinator: %{
          name: "Karim Teja",
          title: "Associate Director, TKN",
          email: "Karim.Teja@iicanada.net",
          phone: "+1 (403) 478-7867"
        }
      }
    }},
    {7, %{
      title: "Quebec & Maritimes",
      slug: "qm",
      parent_id: 1,
      system_email: {"#{@system_email_prefix} - Quebec & Maritimes", "qm.ots@iicanada.net"},
      ots_website: Path.join([@global_url, "/canada"]),
      council_website: @canada_council_website,
      jumbotron: %{
        image_url: "/static/images/global-center-for-pluralism.jpg",
        spanner_bg_color: "#971421"
      },
      marketing_request: %{
        strategy: :direct,
        email: ["shamila.ilyasi@iicanada.net"],
        # NOTE: Do not change this. We can't properly validate requests
        # when regions have different channels available. This is a temporary
        # edge-case that will be corrected later.
        channels: @canada_marketing_channels,
      },
      jamatkhanas: VolunteerHardcoded.construct_jamatkhanas("Quebec & Maritimes", [
        "Brossard",
        "Granby",
        "Headquarters",
        "Laval",
        "Quebec City",
        "Sherbrooke",
      ]),
      disclaimers: @canada_disclaimers,
      tkn: %{
        country: "Canada",
        coordinator: %{
          name: "Karima Ismaili",
          title: "Coordinator, TKN",
          email: "karima.ismaili@iicanada.net",
          phone: "+1 (514) 824-7744"
        }
      }
    }}
  ]
end
