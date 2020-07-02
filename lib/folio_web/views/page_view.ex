defmodule FolioWeb.PageView do
  use FolioWeb, :view
  alias Phoenix.Router.Helpers

  def group_ideas_by(sort, ideas) do
    groupfn = case sort do
      {:bytag, _} -> fn i -> i.tag end
      {:bydate, _} -> fn i -> {i.inserted_at.year, i.inserted_at.month} end
    end

  	ideas = ideas 
  	|> Enum.group_by(groupfn)
  	|> Enum.sort_by(fn {g, _} -> g end)
    |> Enum.map(fn g -> 
        case g do
        {{year, month}, ideas} -> { "#{year}/#{month}", ideas }
        _ -> g
        end
    end)

    ideas2 = case sort do
      {_, :desc} -> Enum.reverse(ideas)
      {_, :asc} -> ideas
      _ -> ideas
    end
    ideas2
  end
  def empty("") do "<Empty>" end
  def empty(s) do s end
  def date_short_fmt(date) do
  	"#{date.year}/#{date.month}/#{date.day}"
  end
end
