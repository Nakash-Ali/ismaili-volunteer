defmodule Volunteer.Permissions do
  import Ecto.Query, warn: false
  alias Volunteer.Repo
  alias Volunteer.Permissions.Role

  def assign_role!(user, type) do
    Role.create(user, type)
    |> Repo.insert!()
  end
end
