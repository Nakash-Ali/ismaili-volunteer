defmodule VolunteerHardcoded.Groups do
  use VolunteerHardcoded
  alias VolunteerHardcoded.Regions

  # NOTE: The name of the region at the end of the title must exactly match
  # the title of the region itself. Otherwise, it won't get bolded correctly

  @raw_config [
    {1, %{
      title: "Council for Canada",
      region_id: Regions.get_id_from_title!("Canada"),
    }},
    {2, %{
      title: "Council for Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
    }},
    {3, %{
      title: "Education Board Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
    }},
    {4, %{
      title: "Health Board Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
    }},
    {5, %{
      title: "ITREB Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
    }},
    {6, %{
      title: "Economic Planning Board (EPB) Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
    }},
    {7, %{
      title: "Youth & Sports Board (AKYSB) Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
    }},
    {8, %{
      title: "Council for British Columbia",
      region_id: Regions.get_id_from_title!("British Columbia"),
    }},
    {9, %{
      title: "Community Relations British Columbia",
      region_id: Regions.get_id_from_title!("British Columbia"),
    }},
    {10, %{
      title: "Economic Planning Board (EPB) Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
    }},
    {11, %{
      title: "Social Welfare Board (SWB) Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
    }},
    {12, %{
      title: "Ismaili Volunteers (IV) British Columbia",
      region_id: Regions.get_id_from_title!("British Columbia"),
    }},
    {13, %{
      title: "Quality of Life (QoL) British Columbia",
      region_id: Regions.get_id_from_title!("British Columbia"),
    }},
    {14, %{
      title: "Social Welfare Board (SWB) British Columbia",
      region_id: Regions.get_id_from_title!("British Columbia"),
    }},
    {15, %{
      title: "World Partnership Walk Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
    }},
    {16, %{
      title: "Quality of Life (QoL) Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
    }},
    {17, %{
      title: "Ismaili Volunteers (IV) Canada",
      region_id: Regions.get_id_from_title!("Canada"),
    }},
    {18, %{
      title: "Legal Matters Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
    }},
    {19, %{
      title: "Settlement Portfolio Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
    }},
    {20, %{
      title: "Community Relations Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
    }},
    {21, %{
      title: "Resource Mobilization Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
    }},
    {22, %{
      title: "JK Development and Maintenance Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
    }},
    {23, %{
      title: "Ismaili Transportation Committee Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
    }},
    {24, %{
      title: "Catering Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
    }},
    {25, :delete},
    {26, %{
      title: "Women's Portfolio Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
    }},
    {27, %{
      title: "Ismaili Volunteers (IV) Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
    }},
    {28, %{
      title: "Arts & Culture Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
    }},
    {29, %{
      title: "Audio Visual (AV) Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
    }},
    {30, %{
      title: "Finance Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
    }},
    {31, %{
      title: "Planning, Priorities & Evaluation Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
    }},
    {32, %{
      title: "Care for the Elderly Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
    }},
    {33, %{
      title: "Social Welfare Board (SWB) Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
    }},
    {34, %{
      title: "Education Board Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
    }},
    {35, %{
      title: "Youth & Sports Board (AKYSB) Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
    }},
    {36, %{
      title: "Health Board Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
    }},
    {37, %{
      title: "Economic Planning Board (EPB) Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
    }},
    {38, %{
      title: "Quality of Life (QoL) Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
    }},
    {39, %{
      title: "Communications Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
    }},
    {40, %{
      title: "Council for Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
    }},
    {41, %{
      title: "Youth & Sports Board (AKYSB) Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
    }},
    {42, %{
      title: "Arts & Culture Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
    }},
    {43, %{
      title: "Ismaili Volunteers Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
    }},
    {44, %{
      title: "Care for the Elderly Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
    }},
    {45, %{
      title: "Communications Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
    }},
    {46, %{
      title: "Community Relations Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
    }},
    {47, %{
      title: "Evaluation & Planning Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
    }},
    {48, %{
      title: "Finance Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
    }},
    {49, %{
      title: "Health Board Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
    }},
    {50, %{
      title: "Legal Matters Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
    }},
    {51, %{
      title: "Quality of Life (QoL) Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
    }},
    {52, %{
      title: "Settlement Portfolio Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
    }},
    {53, %{
      title: "Women's Portfolio Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
    }},
    {54, %{
      title: "ITREB Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
    }},
    {55, %{
      title: "Council for Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
    }},
    {56, %{
      title: "ITREB Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
    }},
    {57, %{
      title: "Communications Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
    }},
    {58, %{
      title: "Settlement Portfolio Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
    }},
    {59, %{
      title: "Arts & Culture Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
    }},
    {60, %{
      title: "Property Matters Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
    }},
    {61, %{
      title: "Performance & Evaluation Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
    }},
    {62, %{
      title: "Human Resources Development & Ismaili Volunteers (HRD/IV) Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
    }},
    {63, %{
      title: "Women's Development Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
    }},
    {64, %{
      title: "Care for the Elderly Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
    }},
    {65, %{
      title: "Finance Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
    }},
    {66, %{
      title: "Diversity & Inclusion Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
    }},
    {67, %{
      title: "Community Relations Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
    }},
    {68, %{
      title: "Arts & Culture British Columbia",
      region_id: Regions.get_id_from_title!("British Columbia"),
    }},
    {69, %{
      title: "Women's Portfolio British Columbia",
      region_id: Regions.get_id_from_title!("British Columbia"),
    }},
    {70, %{
      title: "Economic Planning Board (EPB) British Columbia",
      region_id: Regions.get_id_from_title!("British Columbia"),
    }},
    {71, %{
      title: "Youth & Sports Board (AKYSB) British Columbia",
      region_id: Regions.get_id_from_title!("British Columbia"),
    }},
    {72, %{
      title: "Care for the Elderly British Columbia",
      region_id: Regions.get_id_from_title!("British Columbia"),
    }},
    {73, %{
      title: "Health Board British Columbia",
      region_id: Regions.get_id_from_title!("British Columbia"),
    }},
    {74, %{
      title: "World Partnership Walk British Columbia",
      region_id: Regions.get_id_from_title!("British Columbia"),
    }},
    {75, %{
      title: "ITREB Quebec & Maritimes",
      region_id: Regions.get_id_from_title!("Quebec & Maritimes"),
    }},
    {76, %{
      title: "Arts & Culture Quebec & Maritimes",
      region_id: Regions.get_id_from_title!("Quebec & Maritimes"),
    }},
    {77, %{
      title: "Women's Portfolio Quebec & Maritimes",
      region_id: Regions.get_id_from_title!("Quebec & Maritimes"),
    }},
    {78, %{
      title: "Education Board Quebec & Maritimes",
      region_id: Regions.get_id_from_title!("Quebec & Maritimes"),
    }},
    {79, %{
      title: "Health Board Quebec & Maritimes",
      region_id: Regions.get_id_from_title!("Quebec & Maritimes"),
    }},
    {80, %{
      title: "Youth & Sports Board (AKYSB) Quebec & Maritimes",
      region_id: Regions.get_id_from_title!("Quebec & Maritimes"),
    }},
    {81, %{
      title: "Economic Planning Board (EPB) Quebec & Maritimes",
      region_id: Regions.get_id_from_title!("Quebec & Maritimes"),
    }},
    {82, %{
      title: "Settlement Portfolio British Columbia",
      region_id: Regions.get_id_from_title!("British Columbia"),
    }},
    {83, %{
      title: "Education Board British Columbia",
      region_id: Regions.get_id_from_title!("British Columbia"),
    }},
    {84, %{
      title: "Family Mentorship",
      region_id: Regions.get_id_from_title!("Canada"),
    }},
    {85, %{
      title: "Generations (Multi-Generational Housing & Community Centre) Management Committee",
      region_id: Regions.get_id_from_title!("Prairies"),
    }},
    {86, %{
      title: "Communications & Publications",
      region_id: Regions.get_id_from_title!("British Columbia"),
    }},
    {87, %{
      title: "ITREB British Columbia",
      region_id: Regions.get_id_from_title!("British Columbia"),
    }},
    {88, %{
      title: "Care for the Elderly Quebec & Maritimes",
      region_id: Regions.get_id_from_title!("Quebec & Maritimes"),
    }},
    {89, %{
      title: "Communications Quebec & Maritimes",
      region_id: Regions.get_id_from_title!("Quebec & Maritimes"),
    }},
    {90, %{
      title: "External Relations Quebec & Maritimes",
      region_id: Regions.get_id_from_title!("Quebec & Maritimes"),
    }},
    {91, %{
      title: "Finance Quebec & Maritimes",
      region_id: Regions.get_id_from_title!("Quebec & Maritimes"),
    }},
    {92, %{
      title: "Ismaili Volunteers (IV) Quebec & Maritimes",
      region_id: Regions.get_id_from_title!("Quebec & Maritimes"),
    }},
    {93, %{
      title: "Settlement Quebec & Maritimes",
      region_id: Regions.get_id_from_title!("Quebec & Maritimes"),
    }},
    {94, %{
      title: "Social Welfare Board (SWB) Quebec & Maritimes",
      region_id: Regions.get_id_from_title!("Quebec & Maritimes"),
    }},
    {95, %{
      title: "Council for Quebec & Maritimes",
      region_id: Regions.get_id_from_title!("Quebec & Maritimes"),
    }},
    {96, %{
      title: "Property Matters Quebec & Maritimes",
      region_id: Regions.get_id_from_title!("Quebec & Maritimes"),
    }},
    {97, %{
      title: "Education Board Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
    }},
    {98, %{
      title: "Property Matters Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
    }},
    {99, %{
      title: "Diversity & Inclusion Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
    }},
    {100, %{
      title: "Volunteer Resource Management & TKN Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
    }},
    {101, %{
      title: "Human Resources Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
    }},
    {102, %{
      title: "Ismaili Centre, Vancouver",
      region_id: Regions.get_id_from_title!("British Columbia"),
    }},
    {103, %{
      title: "Data Management & Technology Portfolio Canada",
      region_id: Regions.get_id_from_title!("Canada"),
    }},
    {104, %{
      title: "Data Management & Technology Portfolio Ontario",
      region_id: Regions.get_id_from_title!("Ontario"),
    }},
    {105, %{
      title: "Data Management & Technology Portfolio Ottawa",
      region_id: Regions.get_id_from_title!("Ottawa"),
    }},
    {106, %{
      title: "Data Management & Technology Portfolio Edmonton",
      region_id: Regions.get_id_from_title!("Edmonton"),
    }},
    {107, %{
      title: "Data Management & Technology Portfolio Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
    }},
    {108, %{
      title: "Data Management & Technology Portfolio British Columbia",
      region_id: Regions.get_id_from_title!("British Columbia"),
    }},
    {109, %{
      title: "Data Management & Technology Portfolio Quebec & Maritimes",
      region_id: Regions.get_id_from_title!("Quebec & Maritimes"),
    }},
    {110, %{
      title: "Health Board Canada",
      region_id: Regions.get_id_from_title!("Canada"),
    }},
    {111, %{
      title: "ITREB Canada",
      region_id: Regions.get_id_from_title!("Canada"),
    }},
    {112, %{
      title: "Diversity & Inclusion Quebec & Maritimes",
      region_id: Regions.get_id_from_title!("Quebec & Maritimes"),
    }},
    {113, %{
      title: "Diversity & Inclusion Prairies",
      region_id: Regions.get_id_from_title!("Prairies"),
    }},
    {114, %{
      title: "Diversity & Inclusion Edmonton",
      region_id: Regions.get_id_from_title!("Edmonton"),
    }},
    {115, %{
      title: "Diversity & Inclusion British Columbia",
      region_id: Regions.get_id_from_title!("British Columbia"),
    }},
    {116, %{
      title: "Diversity & Inclusion Canada",
      region_id: Regions.get_id_from_title!("Canada"),
    }},
  ]
end
