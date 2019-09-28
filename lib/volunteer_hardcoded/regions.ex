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
      roles: %{},
      system_email: {"#{@system_email_prefix} - Canada", "canada.ots@iicanada.net"},
      ots_website: Path.join([@global_url, "/canada"]),
      council_website: @canada_council_website,
      jumbotron: %{
        image_url: "/static/images/muqarnas.png",
        spanner_bg_color: "#971421"
      },
      marketing_request: %{
        email: [],
        channels: %{}
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
          name: "",
          title: "",
          email: "",
          phone: ""
        }
      }
    }},
    {2, %{
      title: "Ontario",
      slug: nil,
      parent_id: 1,
      roles: %{
        "nabeela.haji@iicanada.net" => "admin",
      },
      system_email: {"#{@system_email_prefix} - Ontario", "ontario.ots@iicanada.net"},
      ots_website: Path.join([@global_url, "/canada"]),
      council_website: @canada_council_website,
      jumbotron: %{
        image_url: "/static/images/ismaili-center-toronto.jpg",
        spanner_bg_color: "#971421"
      },
      marketing_request: %{
        email: ["cfo-announcements@iicanada.net"],
        channels: @canada_marketing_channels
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
      roles: %{
        "saniya.jamal@iicanada.net" => "admin",
        "Faheem.Ali@iicanada.net" => "admin",
        "amaanali.fazal@iicanada.net" => "admin",
        "shelina.dilgir@iicanada.net" => "cc_team"
      },
      system_email: {"#{@system_email_prefix} - British Columbia", "bc.ots@iicanada.net"},
      ots_website: Path.join([@global_url, "/canada"]),
      council_website: @canada_council_website,
      jumbotron: %{
        image_url: "/static/images/ismaili-center-burnaby-2.jpg",
        spanner_bg_color: "#971421"
      },
      marketing_request: %{
        email: ["farah.surani@iicanada.net"],
        channels: @canada_marketing_channels
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
          name: "Sultana Mithani",
          title: "Associate Director, TKN",
          email: "sultana.mithani@iicanada.net",
          phone: "+1 (604) 376-8818"
        }
      }
    }},
    {4, %{
      title: "Edmonton",
      slug: nil,
      parent_id: 1,
      roles: %{
        "shabeena.habib@iicanada.net" => "admin",
        "debra.somani@iicanada.net" => "admin",
        "shafin.kanji@iicanada.net" => "cc_team",
      },
      system_email: {"#{@system_email_prefix} - Edmonton", "edmonton.ots@iicanada.net"},
      ots_website: Path.join([@global_url, "/canada"]),
      council_website: @canada_council_website,
      jumbotron: %{
        image_url: "/static/images/aga-khan-garden-edmonton.jpg",
        spanner_bg_color: "#971421"
      },
      marketing_request: %{
        email: ["jamil.ramji@gmail.com"],
        channels: @canada_marketing_channels
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
      roles: %{
        "femina.kanji@iicanada.net" => "admin",
        "almas.jaffer@iicanada.net" => "admin",
        "aliya.makani@iicanada.net" => "admin",
        "jahangir.valiani@iicanada.net" => "cc_team"
      },
      system_email: {"#{@system_email_prefix} - Ottawa", "ottawa.ots@iicanada.net"},
      ots_website: Path.join([@global_url, "/canada"]),
      council_website: @canada_council_website,
      jumbotron: %{
        image_url: "/static/images/delegation-of-the-ismaili-imamat.jpg",
        spanner_bg_color: "#971421"
      },
      marketing_request: %{
        email: ["jahangir.valliani@iicanada.net"],
        channels: @canada_marketing_channels
      },
      jamatkhanas: [
        "Headquarters",
        "Kingston",
      ],
      disclaimers: @canada_disclaimers,
      tkn: %{
        country: "Canada",
        coordinator: %{
          name: "Farhan Bhayani",
          title: "Associate Director, TKN",
          email: "farhan.bhayani@iicanada.net",
          phone: ""
        }
      }
    }},
    {6, %{
      title: "Prairies",
      slug: nil,
      parent_id: 1,
      roles: %{
        "alykhan.bhimji@iicanada.net" => "admin",
        "zabin.jadavji@iicanada.net" => "admin",
        "fareen.chartrand@iicanada.net" => "admin",
        "faraynaaz.mitha@iicanada.net" => "admin",
        "ranita.charania@iicanada.net" => "admin",
        "sheizana.murji@iicanada.net" => "cc_team"
      },
      system_email: {"#{@system_email_prefix} - Prairies", "prairies.ots@iicanada.net"},
      ots_website: Path.join([@global_url, "/canada"]),
      council_website: @canada_council_website,
      jumbotron: %{
        image_url: "/static/images/prairies-float.jpeg",
        spanner_bg_color: "#971421"
      },
      marketing_request: %{
        email: ["volunteer.prairies@iicanada.net"],
        channels: @canada_marketing_channels
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
      roles: %{
        "shamila.ilyasi@iicanada.net" => "admin",
      },
      system_email: {"#{@system_email_prefix} - Quebec & Maritimes", "qm.ots@iicanada.net"},
      ots_website: Path.join([@global_url, "/canada"]),
      council_website: @canada_council_website,
      jumbotron: %{
        image_url: "/static/images/global-center-for-pluralism.jpg",
        spanner_bg_color: "#971421"
      },
      marketing_request: %{
        email: ["shamila.ilyasi@iicanada.net"],
        channels: @canada_marketing_channels
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
