defmodule Volunteer.Repo.Migrations.RedoRoles do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :relation, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      add :group_id, references(:groups, on_delete: :delete_all), null: true
      add :region_id, references(:regions, on_delete: :delete_all), null: true
      add :listing_id, references(:listings, on_delete: :delete_all), null: true

      timestamps()
    end

    Enum.each(
      ["group_id", "region_id", "listing_id"],
      fn key ->
        execute("CREATE UNIQUE INDEX roles_user_id_#{key}_not_null_unique ON roles (user_id, #{key}) WHERE #{key} IS NOT NULL;");
      end
    )

    create constraint(
      :roles,
      "exclusive_arc",
      check: "((group_id is not null)::integer + (region_id is not null)::integer + (listing_id is not null)::integer) = 1"
    )
  end
end
