defmodule Folio.Wiki.Idea do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ideas" do
    field :content, :string
    field :tag, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(idea, attrs) do
    idea
    |> cast(attrs, [:tag, :title, :content])
    |> validate_required([:tag, :title])
  end

  def prep_changes(idea, attrs) do
    idea
    |> cast(attrs, [:tag, :title, :content])
  end
end
