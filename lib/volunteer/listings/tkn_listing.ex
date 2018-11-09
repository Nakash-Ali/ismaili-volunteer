defmodule Volunteer.Listings.TKNListing do
  use Volunteer, :schema
  import Ecto.Changeset
  alias Volunteer.Listings.TKNListing
  alias Volunteer.Listings.Listing

  schema "tkn_listings" do
    field :openings, :integer
    field :commitment_type, :string
    field :location_type, :string
    field :search_scope, :string
    field :suggested_keywords, :string

    field :function, :string, default: ""
    field :industry, :string, default: ""
    field :education_level, :string, default: ""
    field :work_experience_level, :string, default: ""

    belongs_to :listing, Listing

    timestamps()
  end

  @attributes_cast_always [
    :listing_id,
    :openings,
    :commitment_type,
    :location_type,
    :search_scope,
    :suggested_keywords,
    :function,
    :industry,
    :education_level,
    :work_experience_level
  ]

  @attributes_required_always [
    :listing_id,
    :openings,
    :commitment_type,
    :location_type,
    :search_scope,
    :suggested_keywords
  ]

  def commitment_type_choices do
    [
      "Full-time",
      "Part-time",
      "Both"
    ]
  end

  def location_type_choices do
    [
      "On-site",
      "Remote / Homebase",
      "Both"
    ]
  end

  def search_scope_choices do
    [
      "In-country",
      "International"
    ]
  end

  def function_choices do
    [
      "Administration and operations",
      "Program development / implementation",
      "Strategic",
      "Team / event-based"
    ]
  end

  def industry_choices do
    [
      "Accounting",
      "Administration",
      "Agriculture, Farming, Forestry",
      "Allied Health",
      "Applied Arts",
      "Audit",
      "Automotive",
      "Banking & Insurance",
      "Business Owner (small/medium/large)",
      "Construction",
      "Counseling",
      "Dentistry",
      "Education / Training",
      "Engineering",
      "Finance",
      "Government / Politics",
      "Home-maker / Housewife",
      "Human Resources (HR)",
      "Information Technology (IT)",
      "Insurance",
      "Legal",
      "Materials Management",
      "Media, Journalism, Communications, & PR",
      "Medical Doctor",
      "Nursing",
      "Pharmacy",
      "Policy / Global development",
      "Real Estate",
      "Research & Development (R&D)",
      "Safety & Security / Law Enforcement",
      "Sales & Marketing",
      "Sports & Recreation",
      "Strategy & Management Consulting",
      "Trades",
      "Transportation",
      "Travel / Tourism / Hospitality",
      "Urban / Land Planning",
      "Other"
    ]
  end

  def education_level_choices do
    [
      "Primary",
      "High School / Secondary",
      "College Diploma",
      "Undergraduate (Bachelors)",
      "Professional School",
      "Masters",
      "PhD"
    ]
  end

  def work_experience_level_choices do
    [
      "Less than 1 year",
      "1 - 2 years",
      "3 - 5 years",
      "6 - 9 years",
      "10 - 14 years",
      "More than 15 years"
    ]
  end

  def sanitize(attrs) do
    attrs
    |> Volunteer.SanitizeInput.text_attrs(["suggested_keywords"])
  end

  def changeset(%TKNListing{} = tkn_listing, %{} = attrs, %Listing{} = listing) do
    new_attrs =
      attrs
      |> Map.put("listing_id", listing.id)

    changeset(tkn_listing, new_attrs)
  end

  def changeset(%TKNListing{} = tkn_listing, %{} = attrs) do
    tkn_listing
    |> cast(sanitize(attrs), @attributes_cast_always)
    |> validate_required(@attributes_required_always)
    |> foreign_key_constraint(:listing_id)
    |> validate_inclusion(:commitment_type, commitment_type_choices())
    |> validate_inclusion(:location_type, location_type_choices())
    |> validate_inclusion(:search_scope, search_scope_choices())
    |> validate_inclusion(:function, function_choices())
    |> validate_inclusion(:industry, industry_choices())
    |> validate_inclusion(:education_level, education_level_choices())
    |> validate_inclusion(:work_experience_level, work_experience_level_choices())
  end
end
