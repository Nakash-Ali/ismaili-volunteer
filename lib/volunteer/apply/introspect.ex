defmodule Volunteer.Apply.Introspect do
  def has_open_applicants?(listing) do
    case listing.applicants do
      %Ecto.Association.NotLoaded{} ->
        raise "Applicants not loaded for listing"

      [] ->
        false

      [_applicant | _] ->
        true
    end
  end
end
