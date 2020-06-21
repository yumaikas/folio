defmodule FolioWeb.LayoutView do
  use FolioWeb, :view

  def title() do
  	System.get_env("TITLE") || "Folio"
  end
end
