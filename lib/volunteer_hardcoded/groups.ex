defmodule VolunteerHardcoded.Groups do
  use VolunteerHardcoded
  alias VolunteerHardcoded.Regions

  # NOTE: The name of the region at the end of the title must exactly match
  # the title of the region itself. Otherwise, it won't get bolded correctly

  @raw_config [
    {1, %{
      title: "Council for Canada",
      region_id: Regions.get_id_from_title!("Canada"),
      roles: %{}
    }},
    {2, %{
      title: "Council for Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
      roles: %{}
    }},
    {3, %{
      title: "Education Board Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
      roles: %{
        "rahima.alani2@iicanada.net" => "admin",
        "armeen.dhanjee@iicanada.net" => "admin"
      }
    }},
    {4, %{
      title: "Health Board Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
      roles: %{
        "aly-khan.lalani@iicanada.net" => "admin",
        "anar.pardhan@iicanada.net" => "admin",
        "salima.k.shariff@iicanada.net" => "admin"
      }
    }},
    {5, %{
      title: "ITREB Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
      roles: %{
        "salima.khakoo@iicanada.net" => "admin",
        "shalina.valimohamed@iicanada.net" => "admin",
      }
    }},
    {6, %{
      title: "Economic Planning Board (EPB) Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
      roles: %{
        "anaar.dhanji@iicanada.net" => "admin",
        "amreen.poonawala@iicanada.net" => "admin",
        "ontario.epb.pm@iicanada.net" => "admin"
      }
    }},
    {7, %{
      title: "Youth & Sports Board (AKYSB) Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
      roles: %{
        "azrah.manji@iicanada.net" => "admin",
        "fazila.jiwa@iicanada.net" => "admin",
        "hussain.peermohammad@iicanada.net" => "admin",
      }
    }},
    {8, %{
      title: "Council for British Columbia",
      region_id: Regions.get_id_from_title!("British Columbia"),
      roles: %{}
    }},
    {9, %{
      title: "Community Relations British Columbia",
      region_id: Regions.get_id_from_title!("British Columbia"),
      roles: %{}
    }},
    {10, %{
      title: "Economic Planning Board (EPB) Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
      roles: %{
        "ali.tejpar@iicanada.net" => "admin"
      }
    }},
    {11, %{
      title: "Social Welfare Board (SWB) Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
      roles: %{
        "rahim.charania@iicanada.net" => "admin"
      }
    }},
    {12, %{
      title: "Ismaili Volunteers (IV) British Columbia",
      region_id: Regions.get_id_from_title!("British Columbia"),
      roles: %{}
    }},
    {13, %{
      title: "Quality of Life (QoL) British Columbia",
      region_id: Regions.get_id_from_title!("British Columbia"),
      roles: %{}
    }},
    {14, %{
      title: "Social Welfare Board (SWB) British Columbia",
      region_id: Regions.get_id_from_title!("British Columbia"),
      roles: %{
        "shirmeen.panju@iicanada.net" => "admin",
        "shahina.jessa@iicanada.net" => "admin",
      }
    }},
    {15, %{
      title: "World Partnership Walk Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
      roles: %{
        "shaneela.jivraj@iicanada.net" => "admin"
      }
    }},
    {16, %{
      title: "Quality of Life (QoL) Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
      roles: %{
        "gulnar.kamadia@iicanada.net" => "admin",
        "nargis.alibhai@iicanada.net" => "admin",
      }
    }},
    {17, %{
      title: "Ismaili Volunteers (IV) Canada",
      region_id: Regions.get_id_from_title!("Canada"),
      roles: %{}
    }},
    {18, %{
      title: "Legal Matters Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "zahra.allidina@iicanada.net" => "admin"
      }
    }},
    {19, %{
      title: "Settlement Portfolio Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "aziz.barna@iicanada.net" => "admin"
      }
    }},
    {20, %{
      title: "Community Relations Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "tasneem.rahim@iicanada.net" => "admin"
      }
    }},
    {21, %{
      title: "Resource Mobilization Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "ayaz.gulamhussein@iicanada.net" => "admin"
      }
    }},
    {22, %{
      title: "JK Development and Maintenance Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "riyaz.virani@iicanada.net" => "admin"
      }
    }},
    {23, %{
      title: "Ismaili Transportation Committee Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "riyaz.virani@iicanada.net" => "admin"
      }
    }},
    {24, %{
      title: "Catering Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "amyn.kanjee@iicanada.net" => "admin"
      }
    }},
    {25, :delete},
    {26, %{
      title: "Women's Portfolio Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "shazia.rahmani@iicanada.net" => "admin"
      }
    }},
    {27, %{
      title: "Ismaili Volunteers (IV) Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "ranita.charania@iicanada.net" => "admin"
      }
    }},
    {28, %{
      title: "Arts & Culture Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "noor.alizada@iicanada.net" => "admin"
      }
    }},
    {29, %{
      title: "Audio Visual (AV) Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "noor.alizada@iicanada.net" => "admin"
      }
    }},
    {30, %{
      title: "Finance Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "ali.malek@iicanada.net" => "admin"
      }
    }},
    {31, %{
      title: "Planning, Priorities & Evaluation Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "narmin.vasanji@iicanada.net" => "admin"
      }
    }},
    {32, %{
      title: "Care for the Elderly Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "arif.manji@iicanada.net" => "admin"
      }
    }},
    {33, %{
      title: "Social Welfare Board (SWB) Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "adam.jivani@iicanada.net" => "admin"
      }
    }},
    {34, %{
      title: "Education Board Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "hassan.odhwani@iicanada.net" => "admin"
      }
    }},
    {35, %{
      title: "Youth & Sports Board (AKYSB) Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "rmoledina@iicanada.net" => "admin"
      }
    }},
    {36, %{
      title: "Health Board Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "zahra.shajani@iicanada.net" => "admin"
      }
    }},
    {37, %{
      title: "Economic Planning Board (EPB) Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "talib.daredia@iicanada.net" => "admin"
      }
    }},
    {38, %{
      title: "Quality of Life (QoL) Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "shaheed.moledina@iicanada.net" => "admin"
      }
    }},
    {39, %{
      title: "Communications Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{
        "sheizana.murji@iicanada.net" => "admin"
      }
    }},
    {40, %{
      title: "Council for Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{}
    }},
    {41, %{
      title: "Youth & Sports Board (AKYSB) Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
      roles: %{
        "bismah.haq@iicanada.net" => "admin"
      }
    }},
    {42, %{
      title: "Arts & Culture Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
      roles: %{
        "salimah.maherali@iicanada.net" => "admin"
      }
    }},
    {43, %{
      title: "Capacity Development & TKN Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
      roles: %{
        "femina.kanji@iicanada.net" => "admin"
      }
    }},
    {44, %{
      title: "Care for the Elderly Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
      roles: %{
        "fatima.alibhai@iicanada.net" => "admin"
      }
    }},
    {45, %{
      title: "Communications Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
      roles: %{
        "jahangir.valiani@iicanada.net" => "admin"
      }
    }},
    {46, %{
      title: "Community Relations Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
      roles: %{
        "fayez.thawer@iicanada.net" => "admin"
      }
    }},
    {47, %{
      title: "Evaluation & Planning Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
      roles: %{
        "fatima.assadzada@iicanada.net" => "admin"
      }
    }},
    {48, %{
      title: "Finance Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
      roles: %{
        "kanwal.karim@iicanada.net" => "admin"
      }
    }},
    {49, %{
      title: "Health Board Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
      roles: %{
        "tasleem.damji@iicanada.net" => "admin"
      }
    }},
    {50, %{
      title: "Legal Matters Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
      roles: %{
        "aleem.abdulla@iicanada.net" => "admin"
      }
    }},
    {51, %{
      title: "Quality of Life (QoL) Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
      roles: %{
        "karim.gwaduri@iicanada.net" => "admin"
      }
    }},
    {52, %{
      title: "Settlement Portfolio Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
      roles: %{
        "tajuddin.akbari@iicanada.net" => "admin"
      }
    }},
    {53, %{
      title: "Women's Portfolio Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
      roles: %{
        "naaz.nathoo@iicanada.net" => "admin"
      }
    }},
    {54, %{
      title: "ITREB Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
      roles: %{
        "danish.sajwani@iicanada.net" => "admin"
      }
    }},
    {55, %{
      title: "Council for Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
      roles: %{}
    }},
    {56, %{
      title: "ITREB Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{}
    }},
    {57, %{
      title: "Communications Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
      roles: %{
        "zahra.nurmohamed@iicanada.net" => "admin",
        "amaanki786@gmail.com" => "admin",
        "khairunissa.gangani@iicanada.net" => "admin"
      }
    }},
    {58, %{
      title: "Settlement Portfolio Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
      roles: %{
        "javid.nasseri@iicanada.net" => "admin"
      }
    }},
    {59, %{
      title: "Arts & Culture Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
      roles: %{
        "hafeez.rupani@iicanada.net" => "admin"
      }
    }},
    {60, %{
      title: "Property Matters Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
      roles: %{
        "fahim.karmali@iicanada.net" => "admin"
      }
    }},
    {61, %{
      title: "Performance & Evaluation Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
      roles: %{
        "suman.budhwani@iicanada.net" => "admin"
      }
    }},
    {62, %{
      title: "Human Resources Development & Ismaili Volunteers (HRD/IV) Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
      roles: %{
        "shiraz.lalani@iicanada.net" => "admin"
      }
    }},
    {63, %{
      title: "Women's Development Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
      roles: %{
        "leena.amiri@iicanada.net" => "admin"
      }
    }},
    {64, %{
      title: "Care for the Elderly Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
      roles: %{
        "dilshad.jiwa@iicanada.net" => "admin"
      }
    }},
    {65, %{
      title: "Finance Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
      roles: %{
        "nadine.vasrani@iicanada.net" => "admin"
      }
    }},
    {66, %{
      title: "Diversity & Inclusion Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
      roles: %{
        "kahtan.aizouki@iicanada.net" => "admin"
      }
    }},
    {67, %{
      title: "Community Relations Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
      roles: %{
        "sadru.jetha@iicanada.net" => "admin"
      }
    }},
    {68, %{
      title: "Arts & Culture British Columbia",
      region_id: Regions.get_id_from_title!("British Columbia"),
      roles: %{
        "samir.modhwadia@iicanada.net" => "admin",
      }
    }},
    {69, %{
      title: "Women's Portfolio British Columbia",
      region_id: Regions.get_id_from_title!("British Columbia"),
      roles: %{}
    }},
    {70, %{
      title: "Economic Planning Board (EPB) British Columbia",
      region_id: Regions.get_id_from_title!("British Columbia"),
      roles: %{
        "farida.bhimji@iicanada.net" => "admin"
      }
    }},
    {71, %{
      title: "Youth & Sports Board (AKYSB) British Columbia",
      region_id: Regions.get_id_from_title!("British Columbia"),
      roles: %{
        "engela.kara@iicanada.net" => "admin"
      }
    }},
    {72, %{
      title: "Care for the Elderly British Columbia",
      region_id: Regions.get_id_from_title!("British Columbia"),
      roles: %{
        "anisha.virani@iicanada.net" => "admin",
      }
    }},
    {73, %{
      title: "Health Board British Columbia",
      region_id: Regions.get_id_from_title!("British Columbia"),
      roles: %{
        "amir.hussein@iicanada.net" => "admin",
      }
    }},
    {74, %{
      title: "World Partnership Walk British Columbia",
      region_id: Regions.get_id_from_title!("British Columbia"),
      roles: %{}
    }},
    {75, %{
      title: "ITREB Quebec & Maritimes",
      region_id: Regions.get_id_from_title!("Quebec & Maritimes"),
      roles: %{
        "moominzada@gmail.com" => "admin",
      }
    }},
    {76, %{
      title: "Arts & Culture Quebec & Maritimes",
      region_id: Regions.get_id_from_title!("Quebec & Maritimes"),
      roles: %{
        "noorzia.shearzad@iicanada.net" => "admin",
      }
    }},
    {77, %{
      title: "Women's Portfolio Quebec & Maritimes",
      region_id: Regions.get_id_from_title!("Quebec & Maritimes"),
      roles: %{
        "neelab.nekzad@iicanada.net" => "admin",
      }
    }},
    {78, %{
      title: "Education Board Quebec & Maritimes",
      region_id: Regions.get_id_from_title!("Quebec & Maritimes"),
      roles: %{
        "iffat.salaam-karim@iicanada.net" => "admin",
      }
    }},
    {79, %{
      title: "Health Board Quebec & Maritimes",
      region_id: Regions.get_id_from_title!("Quebec & Maritimes"),
      roles: %{
        "natasha.nathoo@iicanada.net" => "admin",
      }
    }},
    {80, %{
      title: "Youth & Sports Board (AKYSB) Quebec & Maritimes",
      region_id: Regions.get_id_from_title!("Quebec & Maritimes"),
      roles: %{
        "bohjat.karimi@iicanada.net" => "admin",
      }
    }},
    {81, %{
      title: "Economic Planning Board (EPB) Quebec & Maritimes",
      region_id: Regions.get_id_from_title!("Quebec & Maritimes"),
      roles: %{
        "nichad.dad@iicanada.net" => "admin",
      }
    }},
    {82, %{
      title: "Settlement Portfolio British Columbia",
      region_id: Regions.get_id_from_title!("British Columbia"),
      roles: %{
        "shazma.nazarali@iicanada.net" => "admin"
      }
    }},
    {83, %{
      title: "Education Board British Columbia",
      region_id: Regions.get_id_from_title!("British Columbia"),
      roles: %{
        "shahida.hassanali@iicanada.net" => "admin",
      }
    }},
    {84, %{
      title: "Family Mentorship",
      region_id: Regions.get_id_from_title!("Canada"),
      roles: %{
        "raheem.mussa@iicanada.net" => "admin"
      }
    }},
    {85, %{
      title: "Generations (Multi-Generational Housing & Community Centre) Management Committee",
      region_id: Regions.get_id_from_title!("Prairies"),
      roles: %{}
    }},
    {86, %{
      title: "Communications & Publications",
      region_id: Regions.get_id_from_title!("British Columbia"),
      roles: %{}
    }},
    {87, %{
      title: "ITREB British Columbia",
      region_id: Regions.get_id_from_title!("British Columbia"),
      roles: %{}
    }},
    {88, %{
      title: "Care for the Elderly Quebec & Maritimes",
      region_id: Regions.get_id_from_title!("Quebec & Maritimes"),
      roles: %{}
    }},
    {89, %{
      title: "Communications Quebec & Maritimes",
      region_id: Regions.get_id_from_title!("Quebec & Maritimes"),
      roles: %{}
    }},
    {90, %{
      title: "External Relations Quebec & Maritimes",
      region_id: Regions.get_id_from_title!("Quebec & Maritimes"),
      roles: %{}
    }},
    {91, %{
      title: "Finance Quebec & Maritimes",
      region_id: Regions.get_id_from_title!("Quebec & Maritimes"),
      roles: %{}
    }},
    {92, %{
      title: "Ismaili Volunteers (IV) Quebec & Maritimes",
      region_id: Regions.get_id_from_title!("Quebec & Maritimes"),
      roles: %{}
    }},
    {93, %{
      title: "Settlement Quebec & Maritimes",
      region_id: Regions.get_id_from_title!("Quebec & Maritimes"),
      roles: %{}
    }},
    {94, %{
      title: "Social Welfare Board (SWB) Quebec & Maritimes",
      region_id: Regions.get_id_from_title!("Quebec & Maritimes"),
      roles: %{}
    }},
    {95, %{
      title: "Council for Quebec & Maritimes",
      region_id: Regions.get_id_from_title!("Quebec & Maritimes"),
      roles: %{}
    }},
    {96, %{
      title: "Property Matters Quebec & Maritimes",
      region_id: Regions.get_id_from_title!("Quebec & Maritimes"),
      roles: %{}
    }},
  ]
end
