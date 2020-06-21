defmodule FolioWeb.PageController do
  use FolioWeb, :controller
  alias Folio.Wiki
  alias Folio.Wiki.Idea

  def index(conn, _params) do
    ideas = Wiki.list_ideas()
    render(conn, "index.html", ideas: ideas)
  end

  def new(conn, _params) do
    changeset = Wiki.change_idea(%Idea{})
  	render(conn, "new.html", changeset: changeset)
  end

  def tag(conn, %{"tag" => tag}=params) do
  	ideas = Wiki.list_ideas(%{:tag => tag})
  	render(conn, "index.html", ideas: ideas)
  end

  def show(conn, %{"id"=> id} = params) do
  	idea = Wiki.get_idea!(id)
  	render(conn, "idea.html", idea: idea)
  end

  def edit(conn, %{"id" => id} = params) do
  	idea = Wiki.get_idea!(id)
  	changeset = Wiki.change_idea(idea, Map.from_struct(idea))
  	render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"id" => id, "idea" => idea_params} = _params) do
  	{id, ""} = Integer.parse(id)
  	{:ok, idea} = Wiki.update_idea(%Idea{id: id}, idea_params)
  	redirect(conn, to: "/view/idea/#{id}")
  end

  def create(conn, %{"idea" => idea_params} = _params) do
    case Wiki.create_idea(idea_params) do
	    {:ok, _} -> 
		    redirect(conn, to: "/admin")
	    {:error, %Ecto.Changeset{} = changeset} ->
	    	ideas = Wiki.list_ideas()
	    	render(conn, "admin.html", changeset: changeset, ideas: ideas)
	end
  end

  def admin(conn, _params) do
  	ideas = Wiki.list_ideas()
  	changeset = Wiki.change_idea(%Idea{})
  	render(conn, "admin.html", changeset: changeset, ideas: ideas)
  end
end