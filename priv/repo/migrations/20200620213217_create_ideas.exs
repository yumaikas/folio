defmodule Folio.Repo.Migrations.CreateIdeas do
  use Ecto.Migration

  def change do
    create table(:ideas) do
      add :tag, :string
      add :title, :string
      add :content, :string

      timestamps()
    end

  end
end
