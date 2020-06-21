defmodule Folio.Repo.Migrations.CreateIdeaHistories do
  use Ecto.Migration

  def change do
    create table(:idea_histories) do
      add :tag, :string
      add :title, :string
      add :content, :text
      add :idea_id, references(:ideas, on_delete: :nothing)

      timestamps()
    end

    create index(:idea_histories, [:idea_id])
  end
end
