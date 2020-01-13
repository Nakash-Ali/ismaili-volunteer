defmodule Volunteer.Listings.TKN do
  alias Volunteer.Repo
  alias Volunteer.Listings.TKN.Change

  def edit(listing) do
    Change.changeset(listing, %{})
  end

  def update(listing, attrs) do
    Change.changeset(listing, attrs)
    |> Repo.update()
  end

  def send_assignment_spec(listing) do
    # TODO: implement this!
  end

  def validate_tkn_assignment_spec_generation(listing) do
    case listing do
      %{start_date: nil} ->
        {:error, "start_date required"}

      %{start_date: _start_date} ->
        :ok
    end
  end
end
