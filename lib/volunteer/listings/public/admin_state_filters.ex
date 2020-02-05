defmodule Volunteer.Listings.Public.AdminStateFilters do
  import Ecto.Query
  alias Volunteer.Listings.Public.Filters, as: Filters

  def filter(query, filters) when filters == %{} do
    query
  end

  def filter(query, %{non_public: true, approved: true, expired: true}) do
    query
  end

  def filter(query, %{non_public: false, approved: false, expired: false}) do
    from(l in query, where: fragment("1 = 0"))
  end

  def filter(query, %{non_public: false, approved: true, expired: false}) do
    query
    |> Filters.approved()
    |> Filters.unexpired()
  end

  def filter(query, %{non_public: true, approved: true, expired: false}) do
    Filters.non_public_or_approved_unexpired(query)
  end

  def filter(query, %{non_public: false, approved: true, expired: true}) do
    Filters.approved(query)
  end

  def filter(query, %{non_public: true, approved: false, expired: false}) do
    Filters.non_public(query)
  end

  def filter(query, %{non_public: true, approved: false, expired: true}) do
    Filters.non_public_or_expired(query)
  end

  def filter(query, %{non_public: false, approved: false, expired: true}) do
    Filters.expired(query)
  end
end
