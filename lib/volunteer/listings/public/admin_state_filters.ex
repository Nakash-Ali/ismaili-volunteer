defmodule Volunteer.Listings.Public.AdminStateFilters do
  import Ecto.Query
  alias Volunteer.Listings.Public.Filters, as: Filters

  def filter(query, filters) when filters == %{} do
    query
  end

  def filter(query, %{approved: true, unapproved: true, expired: true}) do
    query
  end

  def filter(query, %{approved: false, unapproved: false, expired: false}) do
    from(l in query, where: fragment("1 = 0"))
  end

  def filter(query, %{approved: true, unapproved: false, expired: false}) do
    query
    |> Filters.approved()
    |> Filters.unexpired()
  end

  def filter(query, %{approved: true, unapproved: true, expired: false}) do
    Filters.approved_or_unapproved_but_unexpired(query)
  end

  def filter(query, %{approved: true, unapproved: false, expired: true}) do
    Filters.approved(query)
  end

  def filter(query, %{approved: false, unapproved: true, expired: false}) do
    Filters.unapproved(query)
  end

  def filter(query, %{approved: false, unapproved: true, expired: true}) do
    Filters.unapproved_or_expired(query)
  end

  def filter(query, %{approved: false, unapproved: false, expired: true}) do
    Filters.expired(query)
  end
end
