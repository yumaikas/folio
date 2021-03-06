defmodule Folio.Wiki do
  @moduledoc """
  The Wiki context.
  """

  import Ecto.Query, warn: false
  alias Folio.Repo

  alias Folio.Wiki.Idea
  alias Folio.Wiki.IdeaHistory 

  @doc """
  Returns the list of ideas.

  ## Examples

      iex> list_ideas()
      [%Idea{}, ...]

  """
  def list_ideas do
    Repo.all(from i in Idea, order_by: [desc: i.updated_at])
  end

  def list_ideas(%{:tag => tag}) do
    Repo.all(from i in Idea, where: i.tag == ^tag)
  end

  def list_ideas(%{:year_month_inserted => year_month}) do
    {year, month} = year_month
    Repo.all(from i in Idea, 
      where: fragment("DATE_PART('year', inserted_at)") == ^year
        and fragment("DATE_PART('month', inserted_at)") == ^month)
  end

  def list_ideas(%{:year_month_updated => year_month}) do
    {year, month} = year_month
    Repo.all(from i in Idea, 
      where: fragment("DATE_PART('year', updated_at)") == ^year
        and fragment("DATE_PART('month', updated_at)") == ^month)
  end


  @doc """
  Gets a single idea.

  Raises `Ecto.NoResultsError` if the Idea does not exist.

  ## Examples

      iex> get_idea!(123)
      %Idea{}

      iex> get_idea!(456)
      ** (Ecto.NoResultsError)

  """
  def get_idea!(id), do: Repo.get!(Idea, id)

  @doc """
  Creates a idea.

  ## Examples

      iex> create_idea(%{field: value})
      {:ok, %Idea{}}

      iex> create_idea(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_idea(attrs \\ %{}) do
    %Idea{}
    |> Idea.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a idea.

  ## Examples

      iex> update_idea(idea, %{field: new_value})
      {:ok, %Idea{}}

      iex> update_idea(idea, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_idea(%Idea{:id => id} = idea, attrs) do
    Repo.transaction(fn ->
      old_idea = Repo.get!(Idea, id)

      idea |> Idea.changeset(attrs)
      |> Repo.update()

      Repo.insert!(%IdeaHistory{
        content: old_idea.content,
        tag: old_idea.tag,
        title: old_idea.title,
        idea_id: old_idea.id
      })
     end)
  end

  def delete_idea(%Idea{} = idea) do
     Repo.delete(idea)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking idea changes.

  ## Examples

      iex> change_idea(idea)
      %Ecto.Changeset{data: %Idea{}}

  """
  def change_idea(%Idea{} = idea, attrs \\ %{}) do
    Idea.changeset(idea, attrs)
  end

  def changeset(%Idea{} = idea, attrs \\ %{}) do
    Idea.prep_changes(idea, attrs)
  end


end
