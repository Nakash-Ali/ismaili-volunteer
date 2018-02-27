defmodule Volunteer.Apply do

  import Ecto.Query, warn: false
  alias Volunteer.Repo

  alias Volunteer.Apply.Listing
  alias Volunteer.Apply.TKNListing
  alias Volunteer.Apply.Application

  def create_listing!(attrs, group, organizer) do
    %Listing{}
    |> Listing.changeset(attrs, group, organizer)
    |> Repo.insert!()
  end

end
