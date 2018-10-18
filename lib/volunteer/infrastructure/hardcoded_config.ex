defmodule Volunteer.Infrastructure.HardcodedConfig do
  @config_by_region %{
    # Canada
    1 => %{
      system_email: {"OpportunitiesToServe", "hrontario@iicanada.net"},
      marketing_request_email: []
    },
    # Ontario
    2 => %{
      system_email: {"OpportunitiesToServe", "hrontario@iicanada.net"},
      marketing_request_email: ["cfo-announcements@iicanada.net"]
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
