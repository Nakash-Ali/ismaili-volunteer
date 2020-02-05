defmodule Volunteer.Listings.Listing do
  use Volunteer, :schema
  alias Volunteer.Infrastructure.Group
  alias Volunteer.Infrastructure.Region
  alias Volunteer.Accounts.User

  schema "listings" do
    has_many :roles, Volunteer.Roles.Role
    has_many :applicants, Volunteer.Apply.Applicant

    belongs_to :created_by, User

    field :position_title, :string
    field :program_title, :string, default: ""
    field :summary_line, :string
    belongs_to :region, Region
    belongs_to :group, Group
    belongs_to :organized_by, User

    field :cc_emails, :string, default: ""

    field :start_date, :date
    field :start_date_toggle, :boolean, virtual: true

    field :end_date, :date
    field :end_date_toggle, :boolean, virtual: true

    field :time_commitment_amount, :integer
    field :time_commitment_type, :string

    field :program_description, :string
    field :responsibilities, :string
    field :qualifications, :string

    field :qualifications_required, {:array, :string}

    # TODO: CC'ed users (properly)
    # TODO: other attached users

    #########################
    # Public listing fields #
    #########################

    field :public_expiry_date, :utc_datetime
    field :public_expiry_reminder_sent, :boolean

    # TODO: move this to logs
    field :public_approved, :boolean, default: false
    field :public_approved_on, :utc_datetime
    belongs_to :public_approved_by, User, on_replace: :nilify

    # TODO: field :public_approval_request_sent, :boolean, default: false
    # TODO: field :public_marketing_request_sent, :boolean, default: false

    ######################
    # TKN listing fields #
    ######################

    field :tkn_openings, :integer
    field :tkn_classification, :string
    field :tkn_commitment_type, :string
    field :tkn_location_type, :string
    field :tkn_search_scope, :string
    field :tkn_suggested_keywords, :string
    field :tkn_eoa_evaluation, :boolean

    field :tkn_function, :string, default: ""
    field :tkn_industry, :string, default: ""
    field :tkn_education_level, :string, default: ""
    field :tkn_work_experience_years, :string, default: ""

    # TODO: implement this!
    # TODO: move this to logs
    field :tkn_assignment_spec_sent, :boolean, default: false

    ################
    # Other fields #
    ################

    timestamps()
  end
end
