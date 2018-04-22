defmodule VolunteerWeb.PageTitle do
  
  # TODO: turn this into a protocl that each view can implement
  
  @suffix Application.fetch_env!(:volunteer, :project_title)
  @joiner " - "
  
  def render(assigns) do
    assigns
    |> get
    |> join
  end
  
  defp get(%{view_module: view_module} = assigns) do
    case Kernel.function_exported?(view_module, :page_title, 1) do
      true ->
        view_module.page_title(assigns)
      false ->
        []
    end
  end
  
  defp join(title_string) when is_binary(title_string) do
    join([title_string])
  end
  
  defp join(list_of_title_strings) when is_list(list_of_title_strings) do
    [ @suffix | list_of_title_strings ]
    |> Enum.reverse
    |> Enum.join(@joiner)
  end
end
