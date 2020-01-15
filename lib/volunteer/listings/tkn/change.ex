defmodule Volunteer.Listings.TKN.Change do
  import Ecto.Changeset
  alias Volunteer.Listings

  @attributes_cast_always [
    :start_date,
    :tkn_openings,
    :tkn_classification,
    :tkn_commitment_type,
    :tkn_location_type,
    :tkn_search_scope,
    :tkn_suggested_keywords,
    :tkn_eoa_evaluation,
    :tkn_function,
    :tkn_industry,
    :tkn_education_level,
    :tkn_work_experience_years
  ]

  @attributes_required_always [
    :start_date,
    :tkn_openings,
    :tkn_classification,
    :tkn_commitment_type,
    :tkn_location_type,
    :tkn_search_scope,
    :tkn_suggested_keywords,
    :tkn_eoa_evaluation,
  ]

  @attributes_sanitize_text [
    :tkn_suggested_keywords
  ]

  def classification_choices do
    [
      "Professional",
      "Administrative",
      "Team"
    ]
  end

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
      "Administration and Operations",
      "Program Development / Implementation",
      "Team / Event-based"
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

  def work_experience_years_choices do
    [
      "Less than 1 year",
      "1 - 2 years",
      "3 - 5 years",
      "6 - 9 years",
      "10 - 14 years",
      "More than 15 years"
    ]
  end

  def update(listing, new_attrs \\ %{})

  def update(%Listings.Listing{id: id} = listing, new_attrs) when is_map(new_attrs) do
    original_attrs =
      Map.from_struct(listing)

    %Listings.Listing{id: id}
    |> cast(original_attrs, @attributes_cast_always)
    |> cast(new_attrs, @attributes_cast_always)
    |> Volunteer.StringSanitizer.sanitize_changes(@attributes_sanitize_text, %{type: :text})
    |> validate_required(@attributes_required_always)
    |> validate_number(:tkn_openings, greater_than: 0)
    |> validate_inclusion(:tkn_classification, classification_choices())
    |> validate_inclusion(:tkn_commitment_type, commitment_type_choices())
    |> validate_inclusion(:tkn_location_type, location_type_choices())
    |> validate_inclusion(:tkn_search_scope, search_scope_choices())
    |> validate_inclusion(:tkn_function, function_choices())
    |> validate_inclusion(:tkn_industry, industry_choices())
    |> validate_inclusion(:tkn_education_level, education_level_choices())
    |> validate_inclusion(:tkn_work_experience_years, work_experience_years_choices())
  end
end
