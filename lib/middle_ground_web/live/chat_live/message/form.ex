defmodule MiddleGroundWeb.ChatLive.Message.Form do
  use MiddleGroundWeb, :live_component
  import MiddleGroundWeb.CoreComponents
  alias MiddleGround.QuestionChat
  alias MiddleGround.QuestionChat.Message

  def update(assigns, socket) do
    message_struct = struct(Message, assigns)
    changeset = QuestionChat.change_message(message_struct)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  def assign_changeset(socket) do
    assign(socket, :changeset, QuestionChat.change_message(%Message{}))
  end

  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        for={@new_message_form}
        phx-submit="save"
        phx-change="update"
        phx-target={@myself}
      >
        <.input
          autocomplete="off"
          phx-keydown={show_modal("edit_message")}
          phx-key="ArrowUp"
          phx-focus="unpin_scrollbar_from_top"
          field={@new_message_form[:message_content]}
        />
        <:actions>
          <.button>send</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def handle_event("update", %{"message" => %{"message_content" => message_content}}, socket) do
    {:noreply, socket |> assign(:changeset, QuestionChat.change_message(%Message{message_content: message_content}))}
  end

  def handle_event("save", %{"message" => %{"message_content" => message_content}}, socket) do
    case QuestionChat.create_message(%{
      message_content: message_content,
      chat_id: socket.assigns.chat_id,
      user_id: socket.assigns.user_id
    }) do
      {:ok, _message} ->
        {:noreply, assign(socket, :new_message_form, %Message{})}
      {:error, changeset} ->
        {:noreply, assign(socket, :new_message_form, to_form(changeset))}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :new_message_form, to_form(changeset))
  end
end
