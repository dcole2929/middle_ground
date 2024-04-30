defmodule MiddleGround.QuestionChatFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MiddleGround.QuestionChat` context.
  """

  @doc """
  Generate a chat.
  """
  def chat_fixture(attrs \\ %{}) do
    {:ok, chat} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> MiddleGround.QuestionChat.create_chat()

    chat
  end
end
