defmodule VolunteerWeb.HTMLHelpers do
  use VolunteerWeb, :view

  defguard is_non_empty_binary(text) when is_binary(text) and text != ""

  def link_action(opts) when is_list(opts) do
    allowed? = Keyword.fetch!(opts, :allowed?)
    text = Keyword.fetch!(opts, :text)
    to = Keyword.fetch!(opts, :to)
    btn = Keyword.get(opts, :btn, "outline-primary")

    opts = Keyword.drop(opts, [:allowed?, :text, :to, :btn])

    if allowed? do
      VolunteerUtils.Keyword.raise_if_present!(opts, [:class])
      Phoenix.HTML.Link.link(text, [to: to, class: "btn btn-#{btn}"] ++ opts)
    else
      not_allowed = " (not allowed)"

      text_with_not_allowed =
        case text do
          text when is_binary(text) ->
            text <> not_allowed

          {:safe, content} ->
            {:safe, content ++ [not_allowed]}
        end

      link_action_disabled([text: text_with_not_allowed, btn: "outline-secondary"] ++ opts)
    end
  end

  def link_action_allowed(opts) do
    if Keyword.fetch!(opts, :allowed?) do
      text = Keyword.fetch!(opts, :text)
      to = Keyword.fetch!(opts, :to)
      btn = Keyword.get(opts, :btn, "outline-primary")

      opts = Keyword.drop(opts, [:allowed?, :text, :to, :btn])

      VolunteerUtils.Keyword.raise_if_present!(opts, [:class])
      Phoenix.HTML.Link.link(text, [to: to, class: "btn btn-#{btn}"] ++ opts)
    end
  end

  def link_action_disabled(opts) do
    text = Keyword.fetch!(opts, :text)
    btn = Keyword.get(opts, :btn, "outline-secondary")

    opts = Keyword.drop(opts, [:text, :btn])

    VolunteerUtils.Keyword.raise_if_present!(opts, [:disabled, :type, :class])

    Phoenix.HTML.Tag.content_tag(
      :button,
      text,
      [disabled: "disabled", type: "button", class: "btn btn-#{btn} disabled"] ++ opts
    )
  end

  def icon_with_text(icon_class, icon_text) do
    ~E"<i class=\"<%= icon_class %> mr-2q\"></i><%= icon_text %>"
  end

  def with_position(list) do
    list
    |> Enum.with_index
    |> with_position([])
  end

  def with_position([], accum) do
    Enum.reverse(accum)
  end

  # NOTE: if there is only one item in the list, :last is preferred over :first
  def with_position([{curr, curr_index}], accum) do
    with_position(
      [],
      [{curr, curr_index, :last} | accum]
    )
  end

  def with_position([{curr, 0} | tail], accum) do
    with_position(
      tail,
      [{curr, 0, :first} | accum]
    )
  end

  def with_position([{curr, curr_index} | tail], accum) do
    with_position(
      tail,
      [{curr, curr_index, nil} | accum]
    )
  end

  def io_join(list, str \\ " ") do
    List.foldr(list, [], fn
      item, [] -> [item]
      item, acc -> [item, str] ++ acc
    end)
  end

  def external_link(text) when is_non_empty_binary(text) do
    external_link(text, text)
  end

  def external_link(_text) do
    nil
  end

  def external_link(text, protocol_or_location, opts \\ [])

  def external_link(text, protocol, opts) when is_non_empty_binary(text) and protocol in [:tel, :mailto] and is_list(opts) do
    link text, [to: "#{protocol}:#{text}"] ++ opts
  end

  def external_link(text, location, opts) when is_non_empty_binary(text) and is_non_empty_binary(location) and is_list(opts) do
    link text, [to: location, target: "_blank"] ++ opts
  end

  def external_link(_text, _protocol, _opts) do
    nil
  end

  def with_line_breaks([]) do
    nil
  end

  def with_line_breaks([content]) do
    content
  end

  def with_line_breaks([content | tail]) do
    ~E"""
      <%= content %>
      <br />
      <%= with_line_breaks(tail) %>
    """
  end

  def default_if_blank do
    "-"
  end

  def default_if_blank?(value) do
    if is_blank?(value) do
      default_if_blank()
    else
      value
    end
  end

  def is_blank?({:safe, value}) do
    is_blank?(value)
  end

  def is_blank?([]) do
    true
  end

  def is_blank?(value) when is_list(value) do
    Enum.all?(value, &is_blank?/1)
  end

  def is_blank?(value) when is_binary(value) do
    case String.trim(value) do
      "" ->
        true

      _ ->
        false
    end
  end

  def is_blank?(nil) do
    true
  end

  def is_blank?(_value) do
    false
  end
end
