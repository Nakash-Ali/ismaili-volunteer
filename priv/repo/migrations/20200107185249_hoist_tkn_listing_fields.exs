defmodule Volunteer.Repo.Migrations.HoistTKNListingFields do
  use Ecto.Migration

  def up do
    alter table(:listings) do
      add :tkn_openings, :integer, default: 0, null: false
      add :tkn_classification, :string, default: "", null: false
      add :tkn_commitment_type, :string, default: "", null: false
      add :tkn_location_type, :string, default: "", null: false
      add :tkn_search_scope, :string, default: "", null: false
      add :tkn_suggested_keywords, :string, default: "", null: false
      add :tkn_eoa_evaluation, :boolean, default: false, null: false

      add :tkn_function, :string, default: "", null: false
      add :tkn_industry, :string, default: "", null: false
      add :tkn_education_level, :string, default: "", null: false
      add :tkn_work_experience_years, :string, default: "", null: false
    end

    flush()

    execute """
            UPDATE listings
            SET    tkn_openings = openings,
                   tkn_classification = classification,
                   tkn_commitment_type = commitment_type,
                   tkn_location_type = location_type,
                   tkn_search_scope = search_scope,
                   tkn_suggested_keywords = suggested_keywords,
                   tkn_eoa_evaluation = eoa_evaluation,
                   tkn_function = function,
                   tkn_industry = industry,
                   tkn_education_level = education_level,
                   tkn_work_experience_years = work_experience_years
            FROM   tkn_listings
            WHERE  tkn_listings.listing_id = listings.id;
            """
  end

  def down do
    alter table(:listings) do
      remove :tkn_openings
      remove :tkn_classification
      remove :tkn_commitment_type
      remove :tkn_location_type
      remove :tkn_search_scope
      remove :tkn_suggested_keywords
      remove :tkn_eoa_evaluation

      remove :tkn_function
      remove :tkn_industry
      remove :tkn_education_level
      remove :tkn_work_experience_years
    end
  end
end
