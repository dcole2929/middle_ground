defmodule MiddleGroundWeb.ChatLive.Message.EditForm do
  use MiddleGroundWeb, :live_component
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

  def render(assigns) do
    ~H"""
    <div>
      <.modal id="edit_message">
        <.simple_form
          for={@message_edit_form}
          phx-submit={JS.push("update") |> hide_modal("edit_message")}
          phx-target={@myself}
        >
          <.input autocomplete="off"
            field={@message_edit_form[:message_content]}
            value={@message_edit_form[:message_content].value}
          />
          <:actions>
            <.button>save</.button>
          </:actions>
        </.simple_form>
      </.modal>
    </div>
    """
  end

  def handle_event("update", %{"message" => %{"message_content" => message_content}}, socket) do
    case QuestionChat.update_message(socket.assigns.message, %{message_content: message_content}) do
      {:ok, message} ->
        {:noreply, assign(socket, :message_edit_form, message: message)}
      {:error, changeset} ->
        {:noreply, assign(socket, :message_edit_form, to_form(changeset))}
    end
  end

  def handle_event("save",%{"message" => %{"message_content" => message_content}}, socket) do
    case QuestionChat.update_chat(socket.assigns.chat, %{message_content: message_content}) do
      {:ok, _chat} ->
        {:noreply, assign(socket, :message_edit_form, %Message{})}
      {:error, changeset} ->
        {:noreply, assign(socket, :message_edit_form, to_form(changeset))}
    end

  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :message_edit_form, to_form(changeset))
  end
end
