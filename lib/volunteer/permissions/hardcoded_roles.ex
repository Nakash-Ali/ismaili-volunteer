defmodule Volunteer.Permissions.HardcodedRoles do
  # @role_types [
  #   "admin",
  # ]

  @roles_by_region %{
    # Canada
    1 => %{},
    # Ontario
    2 => %{
      "nabeela.haji@iicanada.net" => "admin",
    },
    # BC
    3 => %{
      "saniya.jamal@iicanada.net" => "admin",
      "Faheem.Ali@iicanada.net" => "admin"
    },
    # Edmonton
    4 => %{},
    # Ottawa
    5 => %{
      "femina.kanji@iicanada.net" => "admin",
      "almas.jaffer@iicanada.net" => "admin"
    },
    # Prairies
    6 => %{
      "alykhan.bhimji@iicanada.net" => "admin",
    }
  }

  @roles_by_group %{
    # Council for Ontario
    1 => %{},
    # Council for Canada
    2 => %{},
    # Education Board for Ontario
    3 => %{
      "rahima.alani2@iicanada.net" => "admin",
      "armeen.dhanjee@iicanada.net" => "admin"
    },
    # Health Board for Ontario
    4 => %{
      "aly-khan.lalani@iicanada.net" => "admin",
      "anar.pardhan@iicanada.net" => "admin",
      "salima.k.shariff@iicanada.net" => "admin"
    },
    # ITREB Ontario
    5 => %{},
    # Economic Planning Board (EPB) Ontario
    6 => %{
      "farhad.shariff@iicanada.net" => "admin",
      "amreen.poonawala@iicanada.net" => "admin",
      "alykhan.nensi@iicanada.net" => "admin"
    },
    # Youth and Sports Board (AKYSB) Ontario
    7 => %{
      "azrah.manji@iicanada.net" => "admin",
      "fazila.jiwa@iicanada.net" => "admin",
      "hussain.peermohammad@iicanada.net" => "admin",
      "akysbo.communications@iicanada.net" => "admin"
    },
    # Economic Planning Board (EPB) Ottawa
    10 => %{
      "karim.kherani@iicanada.net" => "admin"
    },
    # Social Welfare Board Ottawa
    11 => %{
      "rahim.charania@iicanada.net" => "admin"
    },
    # World Partnership Walk Ontario
    15 => %{
      "shaneela.jivraj@iicanada.net" => "admin"
    },
    # Quality of Life (QOL) Ontario
    16 => %{
      "gulnar.kamadia@iicanada.net" => "admin",
      "nargis.alibhai@iicanada.net" => "admin",
    },
    # Legal Prairies
    18 => %{
      "zahra.allidina@iicanada.net" => "admin"
    },
    # Settlement Prairies
    19 => %{
      "aziz.barna@iicanada.net" => "admin"
    },
    # Community Relations Prairies
    20 => %{
      "tasneem.rahim@iicanada.net" => "admin"
    },
    # Resource Mobilization Prairies
    21 => %{
      "ayaz.gulamhussein@iicanada.net" => "admin"
    },
    # JK Development and Maintenance Prairies
    22 => %{
      "riyaz.virani@iicanada.net" => "admin"
    },
    # Ismaili Transportation Committee Prairies
    23 => %{
      "riyaz.virani@iicanada.net" => "admin"
    },
    # Catering Prairies
    24 => %{
      "amyn.kanjee@iicanada.net" => "admin"
    },
    # Ismaili Volunteers Corp (IVC) Prairies
    25 => %{
      "farid.kassam@iicanada.net" => "admin"
    },
    # Women's Portfolio Prairies
    26 => %{
      "shazia.rahmani@iicanada.net" => "admin"
    },
    # Ismaili Volunteers (IV) Prairies
    27 => %{
      "ranita.charania@iicanada.net" => "admin"
    },
    # Arts & Culture Prairies
    28 => %{
      "noor.alizada@iicanada.net" => "admin"
    },
    # Audio Visual (AV) Prairies
    29 => %{
      "noor.alizada@iicanada.net" => "admin"
    },
    # Finance Prairies
    30 => %{
      "ali.malek@iicanada.net" => "admin"
    },
    # Planning, Priorities & Evaluation Prairies
    31 => %{
      "narmin.vasanji@iicanada.net" => "admin"
    },
    # Care for the Elderly Prairies
    32 => %{
      "arif.manji@iicanada.net" => "admin"
    },
    # Social Welfare Board (SWB) Prairies
    33 => %{
      "adam.jivani@iicanada.net" => "admin"
    },
    # Education Board Prairies
    34 => %{
      "hassan.odhwani@iicanada.net" => "admin"
    },
    # Youth & Sports Board (AKYSB) Prairies
    35 => %{
      "rahim.moledina@iicanada.net" => "admin"
    },
    # Health Board Prairies
    36 => %{
      "zahra.shajani@iicanada.net" => "admin"
    },
    # Economic Planning Board (EPB) Prairies
    37 => %{
      "talib.daredia@iicanada.net" => "admin"
    },
    # Quality of Life (QoL) Prairies
    38 => %{
      "shaheed.moledina@iicanada.net" => "admin"
    },
    # Communications Prairies
    39 => %{
      "sheizana.murji@iicanada.net" => "admin"
    }
  }

  def region_roles(region_id) do
    Map.get(@roles_by_region, region_id, %{})
  end

  def group_roles(group_id) do
    Map.get(@roles_by_group, group_id, %{})
  end

  def region_roles_for_user(user) do
    roles_for_user(@roles_by_region, user)
  end

  def group_roles_for_user(user) do
    roles_for_user(@roles_by_group, user)
  end

  def roles_for_user(roles_by_scope_type, %{primary_email: primary_email}) do
    Enum.reduce(roles_by_scope_type, %{}, fn {scope_id, scope_map}, user_roles ->
      case Map.get(scope_map, primary_email, nil) do
        nil ->
          user_roles

        role ->
          Map.put(user_roles, scope_id, role)
      end
    end)
  end
end
