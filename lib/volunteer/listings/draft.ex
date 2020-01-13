defmodule Volunteer.Listings.Draft do
  def content(organized_by_id) do
    %{
      position_title: "Draft position...",
      summary_line: "Draft summary...",
      time_commitment_amount: "1",
      organized_by_id: organized_by_id,
      start_date: Date.utc_today() |> Date.to_iso8601(),
      end_date: Date.utc_today() |> Date.add(30) |> Date.to_iso8601(),
      program_description: "Draft description...",
      responsibilities: "Draft responsibilities...",
      qualifications: "Draft qualifications..."
    }
  end
end
