defmodule Volunteer.PhoneNormalizer do
  alias Volunteer.Commands

  @command_name "normalize_phone_number"
  @format "E164"
  @region "CA"

  def default_region() do
    @region
  end

  def validate_and_normalize_change(changeset, field) do
    case Ecto.Changeset.fetch_change(changeset, field) do
      :error ->
        changeset

      {:ok, raw_number} ->
        case normalize(raw_number, @region) do
          {:ok, number, _region} ->
            Ecto.Changeset.put_change(changeset, field, number)

          {:error, error} ->
            Ecto.Changeset.add_error(changeset, field, error)
        end
    end
  end

  def normalize(number)  do
    @command_name
    |> Commands.NodeJS.run([%{number: number, format: @format}])
    |> validate_result()
    |> List.first()
  end

  def normalize(number, region) do
    @command_name
    |> Commands.NodeJS.run([%{number: number, region: region, format: @format}])
    |> validate_result()
    |> List.first()
  end

  def normalize_or_default(number, region, default \\ "") do
    case normalize(number, region) do
      {:ok, number, _region} ->
        number

      {:error, _reason} ->
        default
    end
  end

  defp validate_result({:error, _} = error) do
    error
  end

  defp validate_result({:ok, result}) do
    Enum.map(result, fn
      %{"valid" => true, "number" => number, "region" => region} ->
        {:ok, number, region}

      %{"valid" => false, "error" => %{"message" => message}} ->
        {:error, message}

      _ ->
        {:error, "unknown"}
    end)
  end
end
