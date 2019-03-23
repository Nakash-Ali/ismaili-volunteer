defmodule VolunteerHardcoded do
  defmacro __using__(_opts) do
    quote do
      @before_compile VolunteerHardcoded
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      if is_nil(@raw_config) or not is_list(@raw_config) do
        raise "@raw_config must be defined as a list"
      end

      @raw_config
      |> Enum.map(&elem(&1, 0))
      |> Enum.group_by(&(&1))
      |> Enum.filter(&match?({_, list} when is_list(list) and length(list) > 1, &1))
      |> case do
        [] ->
          # we're fine
          true

        dupes ->
          IO.inspect(dupes)
          raise "Found duplicates in #{__MODULE__}"
      end

      @config_by_id Enum.into(@raw_config, %{})

      def config_by_id() do
        @config_by_id
      end

      def fetch_config(id, key_or_keys) do
        case Map.fetch(@config_by_id, id) do
          {:ok, conf} ->
            VolunteerHardcoded.do_fetch_config(conf, key_or_keys)

          :error ->
            {:error, "invalid id"}
        end
      end

      def fetch_config!(id, key_or_keys) do
        case fetch_config(id, key_or_keys) do
          {:ok, conf} ->
            conf

          {:error, reason} ->
            raise reason
        end
      end

      def fetch_config!(id) do
        Map.fetch!(@config_by_id, id)
      end

      def take_from_all!(key_or_keys) do
        VolunteerHardcoded.do_take_from_all!(@config_by_id, key_or_keys)
      end

      def get_id_from_title!(title) do
        @config_by_id
        |> Enum.find_value(fn
          {id, %{title: ^title}} -> id
          _ -> false
        end)
        |> case do
          nil ->
            raise "config with title `#{title}` does not exist"

          id ->
            id
        end
      end
    end
  end

  def construct_jamatkhanas(region_name, jamatkhanas) do
    Enum.map(jamatkhanas, fn jk -> "#{jk}, #{region_name}" end)
  end

  def do_fetch_config(conf, key) when not is_list(key) do
    do_fetch_config(conf, [key])
  end

  def do_fetch_config(conf, keys) when is_list(keys) do
    case VolunteerUtils.Map.fetch_in(conf, keys) do
      :error ->
        {:error, "invalid key"}

      {:ok, {module, func, args}} ->
        {:ok, apply(module, func, args)}

      {:ok, value} ->
        {:ok, value}
    end
  end

  def do_take_from_all!(conf, key_or_keys) do
    conf
    |> Enum.map(fn
      {id, conf} when is_map(conf) ->
        {:ok, value} = do_fetch_config(conf, key_or_keys)
        {id, value}

      {_id, _conf} ->
        nil
    end)
    |> Enum.reject(&is_nil/1)
  end
end
