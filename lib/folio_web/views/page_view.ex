defmodule FolioWeb.PageView do
  use FolioWeb, :view
  alias Phoenix.Router.Helpers

  def group_ideas_by_tag(ideas) do
  	ideas 
  	|> Enum.group_by(fn i -> i.tag end)
  	|> Enum.sort_by(fn {g, _} -> g end)
  end
  def empty("") do "<Empty>" end
  def empty(s) do s end
  def date_short_fmt(date) do
  	"#{date.year}/#{date.month}/#{date.day}"
  end
end
