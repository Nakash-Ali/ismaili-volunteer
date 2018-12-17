defmodule Volunteer.Repo do
  use Ecto.Repo,
    adapter: Ecto.Adapters.Postgres,
    otp_app: :volunteer

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  end

  def seed!(changeset, id) do
    case changeset do
      %{valid?: true} ->
        changeset
        |> Ecto.Changeset.apply_changes()
        |> Map.put(:id, id)
        |> Volunteer.Repo.insert!(on_conflict: :replace_all, conflict_target: :id)

      nil ->
        raise "invalid chanegset for seed"
    end
  end
end
