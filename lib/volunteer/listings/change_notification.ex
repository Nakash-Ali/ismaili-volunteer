defmodule Volunteer.Listings.ChangeNotification do
  alias Volunteer.Repo
  alias Volunteer.Listings.Listing

  def on_approval(listing, approved_by) do
    true = Listing.is_approved?(listing)

    region_emails =
      listing.region_id
      |> Volunteer.Permissions.get_for_region(["cc_team"])
      |> Map.keys()

    email =
      listing
      |> Repo.preload(Listing.preloadables())
      |> VolunteerEmail.ListingsEmails.on_approval(approved_by, region_emails)
      |> VolunteerEmail.Mailer.deliver_now()

    {:ok, email}
  end

  def on_unapproval(_listing, _unapproved_by) do

  end
end
