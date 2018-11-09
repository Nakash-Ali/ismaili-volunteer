defmodule Volunteer.Commands do
  alias Porcelain.{Result, Process}

  def get_node() do
    case Mix.env() do
      :prod -> "nodejs"
      :dev -> "node"
    end
  end

  def run(command_name, config) do
    proc = Porcelain.spawn(get_node(), args(command_name, config), dir: chdir(), err: :out)

    case Process.await(proc, 30_000) do
      {:error, :timeout} ->
        true = Process.stop(proc)
        %Porcelain.Result{status: 0} = pkill(command_name, config)
        {:error, :timeout}

      {:ok, %Result{out: out, status: status}} ->
        IO.inspect(out)

        case status do
          0 ->
            {:ok, decode_or_clean_out(out)}

          _ ->
            {:error, decode_or_clean_out(out)}
        end
    end
  end

  def pkill(command_name, config) do
    Porcelain.exec("pkill", [
      "-fi",
      command_name,
      encode_config(config)
    ])
  end

  def args(command_name, config) do
    [
      "--abort-on-uncaught-exception",
      command_path(command_name),
      "--config=#{encode_config(config)}"
    ]
  end

  def chdir() do
    :code.priv_dir(:volunteer) |> to_string
  end

  def command_path(command_name) do
    "./commands/src/#{command_name}/index.js"
  end

  def encode_config(config) do
    config
    |> Poison.encode!()
    |> Base.encode64()
  end

  def decode_or_clean_out(raw) do
    str = String.trim(raw)

    case Base.decode64(str) do
      {:ok, result} ->
        case Poison.decode(result) do
          {:ok, obj} ->
            obj

          {:error, _} ->
            result
        end

      :error ->
        str
    end
  end
end
