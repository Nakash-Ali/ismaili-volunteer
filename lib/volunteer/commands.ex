defmodule Volunteer.Commands do
  defmodule Core do
    @default_port_opts [
      :exit_status,
      :stderr_to_stdout,
      :binary,
      :eof
    ]

    def exec_cmd(cmd, cmd_args, port_opts \\ [], timeout \\ 5_000) do
      cmd_executable = System.find_executable(cmd)

      port =
        Port.open(
          {:spawn_executable, cmd_executable},
          @default_port_opts ++ port_opts ++ [args: cmd_args]
        )

      case loop(port, timeout, {"", nil}) do
        {:timeout, _acc, _status} = result ->
          terminate!(cmd, cmd_args)
          result

        result ->
          result
      end
    end

    def terminate!(cmd, cmd_args) do
      pkill_target =
        ([cmd] ++ cmd_args)
        |> Enum.join(" ")

      pkill = System.find_executable("pkill")
      pkill_args = ["-KILL", "-fi", pkill_target]

      port =
        Port.open(
          {:spawn_executable, pkill},
          @default_port_opts ++ [args: pkill_args]
        )

      case loop(port, 2_000, {"", nil}) do
        {:timeout, _acc, _status} ->
          raise "Timed-out when trying to terminate #{cmd}"

        {:error, _acc, _status} ->
          IO.puts("Possible zombie cmd: #{inspect(cmd)} with args: #{inspect(cmd_args)}")
          :ok

        {:ok, _acc, _status} ->
          :ok
      end
    end

    def loop(port, timeout, {acc, status}) do
      receive do
        {^port, {:data, data}} ->
          loop(port, timeout, {acc <> data, status})

        {^port, :eof} ->
          send(port, {self(), :close})
          loop(port, 1_000, {acc, status})

        {^port, {:exit_status, exit_status}} ->
          send(port, {self(), :close})
          loop(port, 1_000, {acc, exit_status})

        {^port, :closed} ->
          case status do
            0 ->
              {:ok, acc, 0}

            status ->
              {:error, acc, status}
          end
      after
        timeout ->
          {:timeout, acc, status}
      end
    end

    def priv_dir() do
      :code.priv_dir(:volunteer) |> to_string
    end
  end

  defmodule NodeJS do
    def run(command, config) do
      Core.exec_cmd(
        get_node_executable_name(),
        generate_args(command, config),
        [cd: Core.priv_dir()],
        30_000
      )
      |> case do
        {:ok, result, _status} ->
          {:ok, decode_or_clean_output(result)}

        {:error, result, _status} ->
          {:error, decode_or_clean_output(result)}

        {:timeout, _result, _status} ->
          raise "Timed-out while running #{command}"
      end
    end

    def get_node_executable_name() do
      case Mix.env() do
        :prod -> "nodejs"
        :dev -> "node"
      end
    end

    def generate_args(command, config) do
      [
        "--abort-on-uncaught-exception",
        generate_command_path(command),
        "--config=#{generate_encoded_config(config)}"
      ]
    end

    def generate_command_path(command) do
      "./commands/src/#{command}/index.js"
    end

    def generate_encoded_config(config) do
      config
      |> Jason.encode!()
      |> Base.encode64()
    end

    def decode_or_clean_output(raw) do
      str = String.trim(raw)

      case Base.decode64(str) do
        {:ok, result} ->
          case Jason.decode(result) do
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

  defmodule Bash do
    def unsafe_input_piped_to(unsafe_input, cmd) do
      safe_input = Base.encode64(unsafe_input)
      "echo \"#{safe_input}\" | base64 --decode | #{cmd}"
    end

    def run(bash_str, dir \\ nil)

    def run(bash_str, nil) do
      run(bash_str, Core.priv_dir())
    end

    def run(bash_str, dir) do
      Core.exec_cmd("bash", ["-r", "-c", bash_str], cd: dir)
    end
  end

  defmodule Pandoc do
    def html_to_opendocument(html) do
      html
      |> Bash.unsafe_input_piped_to("pandoc -f html -t opendocument")
      |> Bash.run()
      |> case do
        {:ok, result, _status} ->
          {:ok, result}

        {:error, result, _status} ->
          {:error, result}

        {:timeout, _result, _status} ->
          {:error, :timeout}
      end
    end
  end
end
