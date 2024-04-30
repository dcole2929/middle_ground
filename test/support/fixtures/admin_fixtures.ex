defmodule MiddleGround.AdminFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MiddleGround.Admin` context.
  """

  @doc """
  Generate a question.
  """
  def question_fixture(attrs \\ %{}) do
    {:ok, question} =
      attrs
      |> Enum.into(%{

      })
      |> MiddleGround.Admin.create_question()

    question
  end
end
