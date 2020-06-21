defmodule Folio.Wiki.IdeaHistory do
  use Ecto.Schema
  import Ecto.Changeset

  schema "idea_histories" do
    field :content, :string
    field :tag, :string
    field :title, :string
    field :idea_id, :id

    timestamps()
  end

  @doc false
  def changeset(idea_history, attrs) do
    idea_history
    |> cast(attrs, [:tag, :title, :content])
    |> validate_required([:tag, :title, :content])
  end
end
