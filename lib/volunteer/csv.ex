defmodule Volunteer.CSV do
  def generate(data_list, columns) do
    [generate_headers(columns) | generate_rows(data_list, columns)]
    |> CSV.Encoding.Encoder.encode()
    |> Enum.join("")
  end

  def generate_headers(columns) do
    Enum.map(columns, fn {header, _getter} -> header end)
  end

  def generate_rows(data_list, columns) do
    Enum.map(data_list, fn data ->
      Enum.map(columns, fn
        {_header, func} when is_function(func) -> func.(data)
        {_header, keys} when is_list(keys) -> get_in(data, keys)
      end)
    end)
  end
end
