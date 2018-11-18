defmodule VolunteerWeb.DrafterizeHelpers do
  import Phoenix.HTML

  def formify_draft_content(form, draft_content) do
    for {field, draft} <- draft_content, into: %{} do
      {Phoenix.HTML.Form.input_id(form, field), draft}
    end
  end

  def jsonify_draft_content(form, draft_content) do
    formify_draft_content(form, draft_content)
    |> VolunteerWeb.Presenters.JSON.encode_for_client()
  end

  def draft_content_script_tag(form, draft_content, draft_content_key) do
    ~E"""
    <script type="text/javascript">
      window['<%= draft_content_key %>'] = '<%= jsonify_draft_content(form, draft_content) %>'
    </script>
    """
  end
end
