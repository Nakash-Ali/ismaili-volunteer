defmodule VolunteerHardcoded.Groups do
  use VolunteerHardcoded
  alias VolunteerHardcoded.Regions

  @config_by_id %{
    1 => %{
      title: "Council for Canada",
      region_id: Regions.get_id_from_title!("Canada"),
      roles: %{}
    },
    2 => %{
      title: "Council for Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
      roles: %{}
    },
    3 => %{
      title: "Education Board Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
      roles: %{
        "rahima.alani2@iicanada.net" => "admin",
        "armeen.dhanjee@iicanada.net" => "admin"
      }
    },
    4 => %{
      title: "Health Board Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
      roles: %{
        "aly-khan.lalani@iicanada.net" => "admin",
        "anar.pardhan@iicanada.net" => "admin",
        "salima.k.shariff@iicanada.net" => "admin"
      }
    },
    5 => %{
      title: "ITREB Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
      roles: %{}
    },
    6 => %{
      title: "Economic Planning Board (EPB) Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
      roles: %{
        "farhad.shariff@iicanada.net" => "admin",
        "amreen.poonawala@iicanada.net" => "admin",
        "alykhan.nensi@iicanada.net" => "admin"
      }
    },
    7 => %{
      title: "Youth & Sports Board (AKYSB) Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
      roles: %{
        "azrah.manji@iicanada.net" => "admin",
        "fazila.jiwa@iicanada.net" => "admin",
        "hussain.peermohammad@iicanada.net" => "admin",
        "akysbo.communications@iicanada.net" => "admin"
      }
    },
    8 => %{
      title: "Council for British Columbia",
      region_id: Regions.get_id_from_title!("British Columbia"),
      roles: %{}
    },
    9 => %{
      title: "Community Relations BC",
      region_id: Regions.get_id_from_title!("British Columbia"),
      roles: %{}
    },
    10 => %{
      title: "Economic Planning Board (EPB) Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
      roles: %{
        "ali.tejpar@iicanada.net" => "admin"
      }
    },
    11 => %{
      title: "Social Welfare Board (SWB) Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
      roles: %{
        "rahim.charania@iicanada.net" => "admin"
      }
    },
    12 => %{
      title: "Ismaili Volunteers (IV) BC",
      region_id: Regions.get_id_from_title!("British Columbia"),
      roles: %{}
    },
    13 => %{
      title: "Quality of Life (QoL) BC",
      region_id: Regions.get_id_from_title!("British Columbia"),
      roles: %{}
    },
    14 => %{
      title: "Social Welfare Board (SWB) BC",
      region_id: Regions.get_id_from_title!("British Columbia"),
      roles: %{}
    },
    15 => %{
      title: "World Partnership Walk Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
      roles: %{
        "shaneela.jivraj@iicanada.net" => "admin"
      }
    },
    16 => %{
      title: "Quality of Life (QoL) Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
      roles: %{
        "gulnar.kamadia@iicanada.net" => "admin",
        "nargis.alibhai@iicanada.net" => "admin",
      }
    },
    17 => %{
      title: "Ismaili Volunteers (IV) Canada",
      region_id: Regions.get_id_from_title!("Canada"),
      roles: %{}
    },
    18 => %{
      title: "Legal Matters Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "zahra.allidina@iicanada.net" => "admin"
      }
    },
    19 => %{
      title: "Settlement Portfolio Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "aziz.barna@iicanada.net" => "admin"
      }
    },
    20 => %{
      title: "Community Relations Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "tasneem.rahim@iicanada.net" => "admin"
      }
    },
    21 => %{
      title: "Resource Mobilization Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "ayaz.gulamhussein@iicanada.net" => "admin"
      }
    },
    22 => %{
      title: "JK Development and Maintenance Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "riyaz.virani@iicanada.net" => "admin"
      }
    },
    23 => %{
      title: "Ismaili Transportation Committee Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "riyaz.virani@iicanada.net" => "admin"
      }
    },
    24 => %{
      title: "Catering Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "amyn.kanjee@iicanada.net" => "admin"
      }
    },
    25 => :delete,
    26 => %{
      title: "Women's Portfolio Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "shazia.rahmani@iicanada.net" => "admin"
      }
    },
    27 => %{
      title: "Ismaili Volunteers (IV) Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "ranita.charania@iicanada.net" => "admin"
      }
    },
    28 => %{
      title: "Arts & Culture Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "noor.alizada@iicanada.net" => "admin"
      }
    },
    29 => %{
      title: "Audio Visual (AV) Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "noor.alizada@iicanada.net" => "admin"
      }
    },
    30 => %{
      title: "Finance Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "ali.malek@iicanada.net" => "admin"
      }
    },
    31 => %{
      title: "Planning, Priorities & Evaluation Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "narmin.vasanji@iicanada.net" => "admin"
      }
    },
    32 => %{
      title: "Care for the Elderly Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "arif.manji@iicanada.net" => "admin"
      }
    },
    33 => %{
      title: "Social Welfare Board (SWB) Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "adam.jivani@iicanada.net" => "admin"
      }
    },
    34 => %{
      title: "Education Board Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "hassan.odhwani@iicanada.net" => "admin"
      }
    },
    35 => %{
      title: "Youth & Sports Board (AKYSB) Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "moledina@iicanada.net" => "admin"
      }
    },
    36 => %{
      title: "Health Board Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "zahra.shajani@iicanada.net" => "admin"
      }
    },
    37 => %{
      title: "Economic Planning Board (EPB) Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "talib.daredia@iicanada.net" => "admin"
      }
    },
    38 => %{
      title: "Quality of Life (QoL) Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "shaheed.moledina@iicanada.net" => "admin"
      }
    },
    39 => %{
      title: "Communications Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "sheizana.murji@iicanada.net" => "admin"
      }
    },
    40 => %{
      title: "Council for Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{}
    },
    41 => %{
      title: "Youth & Sports Board (AKYSB) Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
      roles: %{
        "bismah.haq@iicanada.net" => "admin"
      }
    },
    42 => %{
      title: "Arts & Culture Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
      roles: %{
        "salimah.maherali@iicanada.net" => "admin"
      }
    },
    43 => %{
      title: "Capacity Development & TKN Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
      roles: %{
        "femina.kanji@iicanada.net" => "admin"
      }
    },
    44 => %{
      title: "Care for the Elderly Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
      roles: %{
        "fatima.alibhai@iicanada.net" => "admin"
      }
    },
    45 => %{
      title: "Communications Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
      roles: %{
        "jahangir.valiani@iicanada.net" => "admin"
      }
    },
    46 => %{
      title: "Community Relations Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
      roles: %{
        "fayez.thawer@iicanada.net" => "admin"
      }
    },
    47 => %{
      title: "Evaluation & Planning Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
      roles: %{
        "fatima.assadzada@iicanada.net" => "admin"
      }
    },
    48 => %{
      title: "Finance Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
      roles: %{
        "kanwal.karim@iicanada.net" => "admin"
      }
    },
    49 => %{
      title: "Health Board Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
      roles: %{
        "tasleem.damji@iicanada.net" => "admin"
      }
    },
    50 => %{
      title: "Legal Matters Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
      roles: %{
        "aleem.abdulla@iicanada.net" => "admin"
      }
    },
    51 => %{
      title: "Quality of Life (QoL) Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
      roles: %{
        "karim.gwaduri@iicanada.net" => "admin"
      }
    },
    52 => %{
      title: "Settlement Portfolio Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
      roles: %{
        "tajuddin.akbari@iicanada.net" => "admin"
      }
    },
    53 => %{
      title: "Women's Portfolio Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
      roles: %{
        "naaz.nathoo@iicanada.net" => "admin"
      }
    },
    54 => %{
      title: "ITREB Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
      roles: %{
        "danish.sajwani@iicanada.net" => "admin"
      }
    },
    55 => %{
      title: "Council for Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
      roles: %{}
    },
  }
end