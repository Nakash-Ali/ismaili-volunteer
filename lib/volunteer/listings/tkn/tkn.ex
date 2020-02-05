defmodule Volunteer.Listings.TKN do
  alias Volunteer.Repo
  alias Volunteer.Listings.TKN.Change

  def edit(listing) do
    Change.update(listing)
  end

  def update(listing, attrs) do
    Change.update(listing, attrs)
    |> Repo.update()
  end

  def send_tkn_assignment_spec!(spec_url, listing, requested_by) do
    VolunteerEmail.ListingsEmails.tkn_assignment_spec(spec_url, listing, requested_by)
    |> VolunteerEmail.Mailer.deliver_now!()
  end

  def valid?(listing) do
    listing
    |> Change.update()
    |> Map.fetch!(:valid?)
  end
end
