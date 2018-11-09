defmodule VolunteerWeb.Admin.ListingParams do
  defmodule ApproveChecks do
    require Phoenix.HTML
    import Phoenix.HTML

    @checks_content [
      ~E"""
      By approving this listing, I hereby certify that I have reviewed the entire listing to the best of my abilities and have reached out for a second opinion on anything that I am unsure about.
      """,
    ]

    @checks (
      @checks_content
      |> Enum.map(fn {:safe, content} = value ->
        key =
          :md5
          |> :crypto.hash(content)
          |> Base.encode16(case: :lower)
          |> String.to_atom()
        {key, value}
      end)
    )

    @types Enum.map(@checks, fn {key, _value} -> {key, :boolean} end) |> Enum.into(%{})

    @defaults Enum.map(@checks, fn {key, _value} -> {key, :false} end) |> Enum.into(%{})

    def checks() do
      @checks
    end

    def new() do
      {@defaults, @types} |> Ecto.Changeset.change(%{})
    end

    def changeset(params) do
      changes =
        {@defaults, @types}
        |> Ecto.Changeset.cast(params, Map.keys(@types))

      @types
      |> Map.keys()
      |> Enum.reduce(changes, fn key, curr_changeset ->
        Ecto.Changeset.validate_acceptance(curr_changeset, key)
      end)
    end

    def changes_and_data(params) do
      case changeset(params) do
        %{valid?: true} = changes ->
          {changes, Ecto.Changeset.apply_changes(changes)}
        %{valid?: false, data: data} = changes ->
          {changes, data}
      end
    end
  end

  defmodule IndexFilters do
    @types %{
      approved: :boolean,
      unapproved: :boolean,
      expired: :boolean,
    }

    @defaults %{
      approved: true,
      unapproved: true,
      expired: false
    }

    def changeset(nil), do: changeset(%{})
    def changeset(params) do
      {@defaults, @types}
      |> Ecto.Changeset.cast(params, Map.keys(@types))
    end

    def changes_and_data(params) do
      case changeset(params) do
        %{valid?: true} = changes ->
          {changes, Ecto.Changeset.apply_changes(changes)}
        %{valid?: false, data: data} = changes ->
          {changes, data}
      end
    end
  end
end
