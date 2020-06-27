
defmodule Folio.Earmark do
  alias Earmark.Options
  import Earmark.Message, only: [emit_messages: 2, sort_messages: 1]


  def as_html(lines, options \\ %Options{})

  def as_html(lines, options) when is_list(options) do
    as_html(lines, struct(Options, options))
  end

  def as_html(lines, options) do
    {status, ast, messages} = Earmark.as_ast(lines, options)
    {status, Folio.Earmark.Transform.transform(ast, options), messages}
  end

  def as_html!(lines, options \\ %Options{})
  def as_html!(lines, options) when is_list(options) do
    as_html!(lines, struct(Options, options))
  end
  def as_html!(lines, options = %Options{}) do
    {_status, html, messages} = as_html(lines, options)
    emit_messages(messages, options)
    html
  end
end

defmodule Folio.Earmark.Transform do

import Earmark.Helpers, only: [replace: 3]

  @moduledoc """
  This module is a fork of the 
  Earmark transform module that removes all of the indentation 
  and extranous whitespace, to keep links from having an extra space at the end.

  """

  @doc """
  **EXPERIMENTAL**
  But well tested, just expect API changes in the 1.4 branch
  Takes an ast, and optional options (I love this pun), which can be
  a map or keyword list of which the following keys will be used:

  - `smartypants:` `boolean`
  - `initial_indent:` `number`
  - `indent:` `number`

        iex(1)> transform({"p", [], [{"em", [], "help"}, "me"]})
        "<p>\\n  <em>\\n    help\\n  </em>\\n  me\\n</p>\\n"

  Right now only transformation to HTML is supported.

  The transform is also agnostic to any annotation map that is added to the AST.

  Only the `:meta` key is reserved and by passing annotation maps with a `:meta` key
  into the AST the result might become altered or an exception might be raised, otherwise...

        iex(2)> transform({"p", [], [{"em", [], ["help"], %{inner: true}}], %{level: 1}})
        "<p>\\n  <em>\\n    help\\n  </em>\\n</p>\\n"
  """
  def transform(ast, options \\ %{initial_indent: 0, indent: 2})
  def transform(ast, options) when is_list(options) do
    transform(ast, options|>Enum.into(%{initial_indent: 0, indent: 2}))
  end
  def transform(ast, options) when is_map(options) do
    options1 = options
      |> Map.put_new(:indent, 2)

    to_html(ast, options1)
  end


  defp to_html(ast, options) do
    _to_html(ast, options, Map.get(options, :initial_indent, 0)) |> IO.iodata_to_binary
  end

  defp _to_html(ast, options, level, verbatim \\ false)
  defp _to_html(elements, options, level, verbatim) when is_list(elements) do
    elements
    |> Enum.map(&_to_html(&1, options, level, verbatim))
  end
  defp _to_html(element, options, level, false) when is_binary(element) do
    escape(element, options, level)
  end
  defp _to_html(element, options, level, true) when is_binary(element) do
    [make_indent(options, level), element]
  end
  # Void tags: `area`, `br`, `hr`, `img`, and `wbr` are rendered slightly differently
  defp _to_html({"area", _, _}=tag, options, level, _verbatim), do: void_tag(tag, options, level)
  defp _to_html({"br", _, _}=tag, options, level, _verbatim), do: void_tag(tag, options, level)
  defp _to_html({"hr", _, _}=tag, options, level, _verbatim), do: void_tag(tag, options, level)
  defp _to_html({"img", _, _}=tag, options, level, _verbatim), do: void_tag(tag, options, level)
  defp _to_html({"wbr", _, _}=tag, options, level, _verbatim), do: void_tag(tag, options, level)
  defp _to_html({:comment, children}, options, level, _verbatim) do
    indent = make_indent(options, level)
    [ indent,
      "<!--", Enum.intersperse(children, ["\n", indent]), "-->"]
  end
  defp _to_html({tag, atts, []}, options, level, _verbatim) do
    [ make_indent(options, level),
      open_tag(tag, atts),
      "</",
      tag,
      ">" ]
  end
  defp _to_html({"code", atts, children}, options, _level, _verbatim) do
    [ make_indent(options, 0),
      open_tag("code", atts),
      Enum.join(children, "")|>Earmark.Helpers.escape(true),
      "</code>"]
  end
  defp _to_html({"pre", atts, children}, options, level, _verbatim) do
    [ make_indent(options, level),
      open_tag("pre", atts),
      _to_html(children, options, level),
      "</pre>"]
  end
  defp _to_html({"pre", atts, children, meta}, options, level, _verbatim) do
    verbatim = Map.get(meta, :meta, %{}) |> Map.get(:verbatim, false)
    [ make_indent(options, level),
      open_tag("pre", atts),
      _to_html(children, options, level, verbatim),
      "</pre>"]
  end
  defp _to_html({"a", atts, children, meta}, options, level, _verbatim) do
    verbatim = Map.get(meta, :meta, %{}) |> Map.get(:verbatim, false)
    [ make_indent(options, level),
      open_tag("a", atts),
      _to_html(children, options, level, verbatim),
      "</a>"]
  end
  defp _to_html({tag, atts, children}, options, level, _verbatim) do
    [ make_indent(options, level),
      open_tag(tag, atts),
      _to_html(children, options, level+1),
      close_tag(tag, options, level)]
  end
  defp _to_html({tag, atts, children, meta}, options, level, _verbatim) do
    verbatim = Map.get(meta, :meta, %{}) |> Map.get(:verbatim, false)
    [ make_indent(options, level),
      open_tag(tag, atts),
      _to_html(children, options, level+1, verbatim),
      close_tag(tag, options, level)]
  end
  
  defp close_tag(tag, options, level) do
    [make_indent(options, level), "</", tag, ">"]
  end

  defp escape(element, options, level)
  defp escape("", _opions, _level) do
    []
  end
  defp escape(element, options, level) do
    element1 =
        element
        |> smartypants(options)
        |> Earmark.Helpers.escape()
    [make_indent(options, level), element1]
  end

  defp make_att(name_value_pair, tag)
  defp make_att({name, value}, _) do
    [" ", name, "=\"", value, "\""]
  end

  defp make_indent(%{indent: indent}, level) do
    ""
  end

  defp open_tag(tag, atts, void? \\ false) do
    closer =
      if void?, do: " />", else: ">"
    ["<", tag, atts |> Enum.map(&make_att(&1, tag)), closer]
  end

  @em_dash_rgx ~r{---}
  @en_dash_rgx ~r{--}
  @dbl1_rgx ~r{(^|[-–—/\(\[\{"”“\s])'}
  @single_rgx ~r{\'}
  @dbl2_rgx ~r{(^|[-–—/\(\[\{‘\s])\"}
  @dbl3_rgx ~r{"}
  defp smartypants(text, options)
  defp smartypants(text, %{smartypants: true}) do
    text
    |> replace(@em_dash_rgx, "—")
    |> replace(@en_dash_rgx, "–")
    |> replace(@dbl1_rgx, "\\1‘")
    |> replace(@single_rgx, "’")
    |> replace(@dbl2_rgx, "\\1“")
    |> replace(@dbl3_rgx, "”")
    |> String.replace("...", "…")
  end
  defp smartypants(text, _options), do: text

  defp void_tag({tag, atts, []}, options, level) do
    [ make_indent(options, level),
      open_tag(tag, atts, true)]
  end

end