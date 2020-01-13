defmodule VolunteerWeb.WorkflowView do
  use VolunteerWeb, :view
  alias VolunteerWeb.HTMLHelpers

  defmodule Step do
    defstruct [:title, :body, :state]
  end

  def render_step(opts, do: body) do
    step =
      %Step{
        title: Keyword.fetch!(opts, :title),
        state: Keyword.fetch!(opts, :state),
        body: body
      }

    render("step.html", step: step)
  end

  def render_workflow([]) do
    nil
  end

  def render_workflow(workflow) when is_list(workflow) do
    render("all.html", workflow: workflow)
  end

  def step_id(step) do
    Slugify.slugify(
      "step-" <> String.downcase(step.title)
    )
  end

  def step_id(step, suffix) do
    step_id(step) <> "-" <> suffix
  end

  def step_icon(%{state: :start}), do: "fas fa-play-circle"
  def step_icon(%{state: :not_relevant}), do: "far fa-circle"
  def step_icon(%{state: :in_progress}), do: "fas fa-dot-circle"
  def step_icon(%{state: :complete}), do: "fas fa-check-circle"
  def step_icon(%{state: :warning}), do: "fas fa-exclamation-circle"

  def step_text_color(%{state: :start}), do: "text-body"
  def step_text_color(%{state: :not_relevant}), do: "text-muted"
  def step_text_color(%{state: :in_progress}), do: "text-complement-one"
  def step_text_color(%{state: :complete}), do: "text-success"
  def step_text_color(%{state: :warning}), do: "text-danger"
end
