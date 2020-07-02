defmodule FolioWeb.PageController do
  use FolioWeb, :controller
  alias Folio.Wiki
  alias Folio.Wiki.Idea


  def index(conn, %{"sort" => sort} = _params) do
    ideas = Wiki.list_ideas()
    sort = case sort do
      "bydate-desc" -> { :bydate, :desc }
      "bydate-asc" -> { :bydate, :asc }
      "bytag-asc" -> { :bytag, :asc }
      "bytag-desc" ->  { :bytag, :desc }
      _ -> { :bytag, :asc }
    end
    render(conn, "index.html", ideas: ideas, sort: sort)
  end

  def index(conn, _params) do
    ideas = Wiki.list_ideas()
    render(conn, "index.html", ideas: ideas, sort: {:bytag, :asc})
  end

  def new(conn, _params) do
    changeset = Wiki.change_idea(%Idea{})
  	render(conn, "new.html", changeset: changeset)
  end

  def tag(conn, %{"tag" => tag} = params) do
  	ideas = Wiki.list_ideas(%{:tag => tag})
  	render(conn, "index.html", ideas: ideas, sort: {:bydate, :asc})
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

  def confirm_delete(conn, %{"id" => id} = _params) do
    idea = Wiki.get_idea!(id)
    render(conn, "confirmdelete.html", idea: idea)
  end

  def delete(conn, %{"id" => id} = _params) do
    {:ok, _ } = id 
    |> Wiki.get_idea!
    |> Wiki.delete_idea
    redirect(conn, to: "/admin")
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
