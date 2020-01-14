defmodule VolunteerWeb.Admin.Listing.TKNView do
  use VolunteerWeb, :view
  alias VolunteerWeb.FormView
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

  def definition_list(:all, listing) do
    [
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
