defmodule VolunteerWeb.TemporalView do
  use VolunteerWeb, :view
  alias VolunteerUtils.Temporal

  def local(%DateTime{} = datetime) do
    content_tag(
      :span,
      "#{Temporal.format_datetime!(datetime)}",
      [
        data: [
          controller: "temporal",
          temporal_iso: DateTime.to_iso8601(datetime, :extended),
          temporal_type: "local"
        ]
      ]
    )
  end
end
