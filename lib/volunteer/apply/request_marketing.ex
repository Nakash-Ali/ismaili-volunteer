defmodule Volunteer.Apply.RequestMarketing do
  import Ecto.Changeset
  
  defmodule Channel do
    @schema %{
      type: :string,
      text: :string,
    }
    
    @required Map.keys(@schema)
    
    @all_types %{
      "aa" => "Al-Akhbar",
      "iicanada" => "IICanada App & Website",
      "jk" => "Jamatkhana announcement",
      "jk-tv" => "Jamatkhana TV"
    }
    
    defstruct Map.keys(@schema)
    
    def create(params) do
      {%__MODULE__{}, @schema}
      |> cast(params, Map.keys(@schema))
      |> validate_required(@required)
      |> validate_inclusion(:type, Map.keys(@all_types))
      |> validate_length(:text, max: 400)
    end
  end
  
  @schema %{
    start_date: :date,
    channels: {:array, Channel},
    target_jamatkhanas: {:array, :string},
  }

  @defaults %{
    channels: []
  }

  @required Map.keys(@schema)
  
  defstruct Map.keys(@schema) |> Enum.map(fn key -> {key, Map.get(@defaults, key, nil)} end)

  def create(params) do
    {%__MODULE__{}, @schema}
    |> cast(params, Map.keys(@schema))
    |> validate_required(@required)
  end
end
