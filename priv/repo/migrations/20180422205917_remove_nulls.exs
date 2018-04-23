defmodule Volunteer.Repo.Migrations.RemoveNulls do
  use Ecto.Migration

  def change do
    alter table(:addresses) do
      modify :line_2, :string, null: false, default: ""
      modify :line_3, :string, null: false, default: ""
      modify :line_4, :string, null: false, default: ""
    end
    
    alter table(:users) do
      modify :primary_phone, :string, null: true, default: ""
    end
    
    alter table(:applications) do
      modify :additional_info, :text, null: false, default: ""
      modify :hear_about, :text, null: false, default: ""
    end
    
    alter table(:listings) do
      modify :program_title, :string, null: false, default: ""
    end
  end
end
