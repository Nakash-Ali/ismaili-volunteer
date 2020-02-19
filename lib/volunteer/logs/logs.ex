defmodule Volunteer.Logs do
  import Ecto.Query
  alias Volunteer.Repo
  alias Volunteer.Multi.Namer
  alias Volunteer.Logs.Log

  def all(listing: %{id: id}) do
    from(l in Log)
    |> where(listing_id: ^id)
    |> order_by(desc: :occured_at)
    |> Repo.all()
  end

  def create(%Ecto.Multi{} = multi, log_opts) when is_map(log_opts) do
    Ecto.Multi.run(multi, :log, fn repo, _prev ->
      create(log_opts, repo)
    end)
  end

  def create(log_opts, repo) when is_map(log_opts) and is_atom(repo) do
    Ecto.Multi.new
    |> Ecto.Multi.insert(:create, Volunteer.Logs.Log.create(log_opts))
    |> repo.transaction
  end
end
