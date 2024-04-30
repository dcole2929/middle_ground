defmodule MiddleGroundWeb.QuestionController do
  use MiddleGroundWeb, :controller

  alias MiddleGround.Question
  alias MiddleGround.Response
  alias MiddleGround.QuestionChat
  alias MiddleGround.QuestionChat.Chat
  alias MiddleGroundWeb.Router.Helpers, as: Routes

  def show(conn, %{"id" => id}) do
    question = Question.get_question!(id)
    render(conn, :show, question: question)
  end

  def submit(conn, %{"id" => id, "response" => response}) do
    question = Question.get_question!(id)
    payload = %{
      "question_id" => question.id,
      "response_type" => response,
      "user_id" => conn.assigns.current_user.id
    }
    case Response.create_response(payload) do
      {:ok, _response} ->
        # check if chat exists
        chat_room = case QuestionChat.get_chat_by_question_id(question.id) do
          # if chat room does not exist, create one
          nil -> QuestionChat.create_chat(%{question_id: question.id, name: question.text})
          # return chat room if one is found
          chat -> {:ok, chat }
        end

        case chat_room do
          {:ok, %Chat{id: chat_id}} ->
            conn
            |> put_flash(:info, "Join the Conversation!")
            |> redirect(to: Routes.chat_root_path(conn, :show, chat_id))
          {:error, _reason} ->
            conn
            |> put_flash(:error, "Unable to create or find chat room.")
            |> redirect(to: Routes.page_path(conn, :index))
        end
      {:error, _} ->
        conn
        |> put_flash(:error, "Error Processing Response!")
        |> redirect(to: url(~p"/questions/#{question}"))
    end
  end


end
