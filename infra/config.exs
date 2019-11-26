defmodule VolunteerInfra.Secrets.Common do
  @gcloud_project "ismailivolunteer-201223"

  def base(_context, env) when env in ["prod", "stg"] do
    git_sha = exec_cmd!("git", ["rev-parse", "HEAD"])
    git_sha_short = exec_cmd!("git", ["rev-parse", "--short", "HEAD"])

    gcloud_version = "#{env}-#{git_sha_short}"

    %{
      gcloud: %{
        project: @gcloud_project,
        version: gcloud_version,
        target_host: "#{gcloud_version}-dot-#{@gcloud_project}.appspot.com"
      },
      git: %{
        sha: git_sha,
        sha_short: git_sha_short
      },
    }
  end

  def exec_cmd!(cmd, args) do
    case System.cmd(cmd, args) do
      {result, 0} ->
        String.trim(result)

      {error_msg, _error_code} ->
        raise "Execution of #{cmd} failed with error '#{error_msg}'"
    end
  end
end

defmodule VolunteerInfra.Config do
  def envvars(context, env) do
    secrets(context, env) |> env_compile
  end

  def secrets(context, env) do
    [{compiled_module, _}] =
      "./infra/config.#{env}.secrets.exs"
      |> Code.compile_file()

    compiled_module.configure(context, env) |> Enum.into([])
  end

  defp env_compile(key_values) do
    key_values
    |> env_from_config()
    |> env_flatten()
    |> Enum.reject(fn {_key, value} -> is_nil(value) end)
    |> Enum.into(%{})
  end

  defp env_from_config(key_values, prefixes \\ []) do
    Enum.map(key_values, fn
      {key, value} when is_map(value) ->
        {env_from_config_key(key, prefixes), env_from_config(value, prefixes ++ [key])}

      {key, value} ->
        {env_from_config_key(key, prefixes), value}
    end)
  end

  defp env_from_config_key(key, prefixes) when is_list(prefixes) do
    (prefixes ++ [key])
    |> Enum.map(&to_string/1)
    |> Enum.map(&String.upcase/1)
    |> Enum.join("_")
  end

  defp env_flatten(key_values) do
    Enum.reduce(key_values, [], fn
      {_key, value}, acc when is_list(value) ->
        env_flatten(value) ++ acc

      pair, acc ->
        [ pair | acc ]
    end)
  end
end
