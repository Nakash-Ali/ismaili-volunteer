defmodule Volunteer.StringSanitizer do
  @empty_values [""]

  def sanitize(list_of_input, opts) when is_list(list_of_input) do
    default_opts = %{
      filter_empty_in_list: true
    }

    opts = Map.merge(default_opts, opts)

    list_of_input =
      Enum.map(list_of_input, &sanitize(&1, opts))

    if opts.filter_empty_in_list do
      Enum.reject(list_of_input, &Enum.member?(@empty_values, &1))
    else
      list_of_input
    end
  end

  def sanitize(nil, _opts) do
    nil
  end

  def sanitize(input, %{type: :text} = opts) do
    default_opts = %{
      normalize_spaces: false
    }

    opts = Map.merge(default_opts, opts)

    if opts.normalize_spaces do
      Regex.replace(~r/\s+/, input, " ")
    else
      input
    end
    |> String.trim()
  end

  def sanitize(input, %{type: {:comma_separated, inner_type}} = opts) do
    input
    |> String.split(",")
    |> sanitize(%{opts | type: inner_type})
    |> Enum.join(",")
  end

  def sanitize(input, %{type: :html}) do
    VolunteerWeb.HTMLInput.sanitize(input)
  end

  def sanitize_changes(changeset, keys_to_sanitize, opts) do
    Enum.reduce(keys_to_sanitize, changeset, fn key, changeset ->
      case Ecto.Changeset.fetch_change(changeset, key) do
        {:ok, value} ->
          Ecto.Changeset.put_change(changeset, key, sanitize(value, opts))

        :error ->
          changeset
      end
    end)
  end
end
