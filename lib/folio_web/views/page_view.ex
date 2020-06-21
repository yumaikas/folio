defmodule FolioWeb.PageView do
  use FolioWeb, :view
  alias Phoenix.Router.Helpers

  def date_short_fmt(date) do
  	"#{date.year}/#{date.month}/#{date.day}"
  end
end
