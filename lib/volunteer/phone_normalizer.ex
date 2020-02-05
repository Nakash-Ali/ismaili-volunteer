defmodule Volunteer.PhoneNormalizer do
  alias Volunteer.Funcs

  @command_name "normalize_phone_number"
  @format "INTERNATIONAL"
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
    |> Funcs.action!(%{number: number, format: @format})
    |> validate_result()
  end

  def normalize(number, region) do
    @command_name
    |> Funcs.action!(%{number: number, region: region, format: @format})
    |> validate_result()
  end

  defp validate_result({:error, %{"error" => "invalid phone number"}}) do
    {:error, "Invalid phone number"}
  end

  defp validate_result({:error, %{"error" => "invalid phone number for region"}}) do
    {:error, "Invalid phone number for region"}
  end

  defp validate_result({:ok, %{"number" => number, "region" => region}}) do
    {:ok, number, region}
  end
end
