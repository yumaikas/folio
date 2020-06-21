defmodule Folio.WikiTest do
  use Folio.DataCase

  alias Folio.Wiki

  describe "ideas" do
    alias Folio.Wiki.Idea

    @valid_attrs %{content: "some content", tag: "some tag", title: "some title"}
    @update_attrs %{content: "some updated content", tag: "some updated tag", title: "some updated title"}
    @invalid_attrs %{content: nil, tag: nil, title: nil}

    def idea_fixture(attrs \\ %{}) do
      {:ok, idea} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Wiki.create_idea()

      idea
    end

    test "list_ideas/0 returns all ideas" do
      idea = idea_fixture()
      assert Wiki.list_ideas() == [idea]
    end

    test "get_idea!/1 returns the idea with given id" do
      idea = idea_fixture()
      assert Wiki.get_idea!(idea.id) == idea
    end

    test "create_idea/1 with valid data creates a idea" do
      assert {:ok, %Idea{} = idea} = Wiki.create_idea(@valid_attrs)
      assert idea.content == "some content"
      assert idea.tag == "some tag"
      assert idea.title == "some title"
    end

    test "create_idea/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Wiki.create_idea(@invalid_attrs)
    end

    test "update_idea/2 with valid data updates the idea" do
      idea = idea_fixture()
      assert {:ok, %Idea{} = idea} = Wiki.update_idea(idea, @update_attrs)
      assert idea.content == "some updated content"
      assert idea.tag == "some updated tag"
      assert idea.title == "some updated title"
    end

    test "update_idea/2 with invalid data returns error changeset" do
      idea = idea_fixture()
      assert {:error, %Ecto.Changeset{}} = Wiki.update_idea(idea, @invalid_attrs)
      assert idea == Wiki.get_idea!(idea.id)
    end

    test "delete_idea/1 deletes the idea" do
      idea = idea_fixture()
      assert {:ok, %Idea{}} = Wiki.delete_idea(idea)
      assert_raise Ecto.NoResultsError, fn -> Wiki.get_idea!(idea.id) end
    end

    test "change_idea/1 returns a idea changeset" do
      idea = idea_fixture()
      assert %Ecto.Changeset{} = Wiki.change_idea(idea)
    end
  end

  describe "idea_histories" do
    alias Folio.Wiki.IdeaHistory

    @valid_attrs %{content: "some content", tag: "some tag", title: "some title"}
    @update_attrs %{content: "some updated content", tag: "some updated tag", title: "some updated title"}
    @invalid_attrs %{content: nil, tag: nil, title: nil}

    def idea_history_fixture(attrs \\ %{}) do
      {:ok, idea_history} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Wiki.create_idea_history()

      idea_history
    end

    test "list_idea_histories/0 returns all idea_histories" do
      idea_history = idea_history_fixture()
      assert Wiki.list_idea_histories() == [idea_history]
    end

    test "get_idea_history!/1 returns the idea_history with given id" do
      idea_history = idea_history_fixture()
      assert Wiki.get_idea_history!(idea_history.id) == idea_history
    end

    test "create_idea_history/1 with valid data creates a idea_history" do
      assert {:ok, %IdeaHistory{} = idea_history} = Wiki.create_idea_history(@valid_attrs)
      assert idea_history.content == "some content"
      assert idea_history.tag == "some tag"
      assert idea_history.title == "some title"
    end

    test "create_idea_history/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Wiki.create_idea_history(@invalid_attrs)
    end

    test "update_idea_history/2 with valid data updates the idea_history" do
      idea_history = idea_history_fixture()
      assert {:ok, %IdeaHistory{} = idea_history} = Wiki.update_idea_history(idea_history, @update_attrs)
      assert idea_history.content == "some updated content"
      assert idea_history.tag == "some updated tag"
      assert idea_history.title == "some updated title"
    end

    test "update_idea_history/2 with invalid data returns error changeset" do
      idea_history = idea_history_fixture()
      assert {:error, %Ecto.Changeset{}} = Wiki.update_idea_history(idea_history, @invalid_attrs)
      assert idea_history == Wiki.get_idea_history!(idea_history.id)
    end

    test "delete_idea_history/1 deletes the idea_history" do
      idea_history = idea_history_fixture()
      assert {:ok, %IdeaHistory{}} = Wiki.delete_idea_history(idea_history)
      assert_raise Ecto.NoResultsError, fn -> Wiki.get_idea_history!(idea_history.id) end
    end

    test "change_idea_history/1 returns a idea_history changeset" do
      idea_history = idea_history_fixture()
      assert %Ecto.Changeset{} = Wiki.change_idea_history(idea_history)
    end
  end
end
