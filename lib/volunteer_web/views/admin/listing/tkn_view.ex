defmodule VolunteerWeb.Admin.Listing.TKNView do
  use VolunteerWeb, :view
  alias VolunteerWeb.FormView
  alias VolunteerWeb.AdminView
  alias VolunteerWeb.ListingView, as: PublicListingView
  alias VolunteerWeb.Admin.ListingView
  alias VolunteerWeb.WorkflowView

  def render("head_extra" <> _, %{conn: conn}) do
    [
      StaticHelpers.stylesheet_tag(conn, "/css/admin/common.css")
    ]
  end

  def render("body_extra" <> page, _) when page in [".edit.html", ".new.html"] do
    [
      render(VolunteerWeb.VendorView, "datepicker.html"),
    ]
  end

  def workflow(%{conn: conn, listing: listing} = assigns) do
    [
      %WorkflowView.Step{
        title: "The TKN Workflow",
        state: :start,
        content: {
          "The TKN Workflow enables you to request volunteers for this listing from TKN.",
          "This workflow will generate the Assignment Specification form and send it to your region's Associate Director for TKN via email on your behalf. From there, you will continue the TKN process over email."
        }
      },
      %WorkflowView.Step{
        title: "Manage Additional Data",
        state: (
          if assigns[:listing_invalid_redirect?] == true do
            :warning
          else
            if assigns[:listing_valid?] == true do
              :complete
            else
              :in_progress
            end
          end
        ),
        content: (
          if assigns[:listing_valid?] == false do
            "Some of the data required for TKN is incorrect or missing. Click on the Edit button below to fix it."
          end
        )
      },
      %WorkflowView.Step{
        title: "TKN Assignment Specification",
        state: (
          if assigns[:listing_valid?] == true do
            :in_progress
          else
            :not_relevant
          end
        ),
        actions: (
          if assigns[:listing_valid?] == true do
            [
              HTMLHelpers.link_action(
                allowed?: ConnPermissions.is_allowed?(conn, [:admin, :listing, :tkn, :spec], listing),
                text: "Send Specification to TKN",
                to: RouterHelpers.admin_listing_tkn_assignment_spec_path(conn, :send, listing),
                method: :post
              ),
              HTMLHelpers.link_action(
                allowed?: ConnPermissions.is_allowed?(conn, [:admin, :listing, :tkn, :spec], listing),
                text: "Download Specification",
                to: RouterHelpers.admin_listing_tkn_assignment_spec_path(conn, :pdf, listing)
              )
            ]
          else
            []
          end
        )
      },
    ]
  end

  def definition_list(:all, listing) do
    [
      {"Start date", PublicListingView.start_date_text(listing.start_date)},
      {"Open positions", listing.tkn_openings},
      {"Classification", listing.tkn_classification},
      {"Commitment type", listing.tkn_commitment_type},
      {"Location type", listing.tkn_location_type},
      {"Search scope", listing.tkn_search_scope},
      {"Suggested keywords", listing.tkn_suggested_keywords},
      {"EOA evaluation", eoa_evaluation_label(listing.tkn_eoa_evaluation)},
      {"Position function", listing.tkn_function},
      {"Position industry", listing.tkn_industry},
      {"Education level", listing.tkn_education_level},
      {"Work experience", listing.tkn_work_experience_years},
    ]
  end

  def eoa_evaluation_label(true) do
    "Yes, required"
  end

  def eoa_evaluation_label(false) do
    "No, not necessary"
  end
end
