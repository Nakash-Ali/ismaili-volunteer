defmodule VolunteerWeb.Presenters.Slugify do
  def slugify(%{id: id} = obj) do
    "#{id} #{VolunteerWeb.Presenters.Title.plain(obj)}"
    |> String.downcase()
    |> Slugger.slugify()
  end
end
