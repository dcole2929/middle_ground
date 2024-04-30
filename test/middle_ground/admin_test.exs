defmodule MiddleGround.AdminTest do
  use MiddleGround.DataCase

  alias MiddleGround.Admin

  describe "questions" do
    alias MiddleGround.Admin.Question

    import MiddleGround.AdminFixtures

    @invalid_attrs %{}

    test "list_questions/0 returns all questions" do
      question = question_fixture()
      assert Admin.list_questions() == [question]
    end

    test "get_question!/1 returns the question with given id" do
      question = question_fixture()
      assert Admin.get_question!(question.id) == question
    end

    test "create_question/1 with valid data creates a question" do
      valid_attrs = %{}

      assert {:ok, %Question{} = question} = Admin.create_question(valid_attrs)
    end

    test "create_question/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_question(@invalid_attrs)
    end

    test "update_question/2 with valid data updates the question" do
      question = question_fixture()
      update_attrs = %{}

      assert {:ok, %Question{} = question} = Admin.update_question(question, update_attrs)
    end

    test "update_question/2 with invalid data returns error changeset" do
      question = question_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_question(question, @invalid_attrs)
      assert question == Admin.get_question!(question.id)
    end

    test "delete_question/1 deletes the question" do
      question = question_fixture()
      assert {:ok, %Question{}} = Admin.delete_question(question)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_question!(question.id) end
    end

    test "change_question/1 returns a question changeset" do
      question = question_fixture()
      assert %Ecto.Changeset{} = Admin.change_question(question)
    end
  end
end
