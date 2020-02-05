defmodule VolunteerWeb.WorkflowView do
  use VolunteerWeb, :view
  alias VolunteerWeb.AdminView

  defmodule Step do
    defstruct [title: nil, state: nil, actions: [], content: nil]
  end

  def next(workflow) do
    Enum.find(workflow, fn
      %{state: state} when state in [:in_progress, :warning] -> true
      _ -> false
    end)
  end

  def step_id(step) do
    Slugify.slugify(
      "step-" <> String.downcase(step.title)
    )
  end

  def step_id(step, suffix) do
    step_id(step) <> "-" <> suffix
  end

  def step_collapsed?(state) when state in [:start, :in_progress, :warning], do: false
  def step_collapsed?(_), do: true

  def step_icon(:start), do: "fas fa-play-circle"
  def step_icon(:info), do: "fas fa-info-circle"
  def step_icon(:not_relevant), do: "far fa-circle"
  def step_icon(:in_progress), do: "fas fa-dot-circle"
  def step_icon(:complete), do: "fas fa-check-circle"
  def step_icon(:warning), do: "fas fa-exclamation-circle"

  def step_text_color(:start), do: "text-body"
  def step_text_color(:info), do: "text-body"
  def step_text_color(:not_relevant), do: "text-muted"
  def step_text_color(:in_progress), do: "text-complement-one"
  def step_text_color(:complete), do: "text-success"
  def step_text_color(:warning), do: "text-danger"

  def content(%{content: {content, _more_content}}), do: content
  def content(%{content: content}), do: content

  def more_content(%{content: {_content, more_content}}), do: more_content
  def more_content(_), do: nil

  def has_content(%{content: {content, _more_content}}), do: not HTMLHelpers.is_blank?(content)
  def has_content(%{content: content}), do: not HTMLHelpers.is_blank?(content)

  def has_more_content(%{content: {_content, more_content}}), do: not HTMLHelpers.is_blank?(more_content)
  def has_more_content(_), do: false
end
