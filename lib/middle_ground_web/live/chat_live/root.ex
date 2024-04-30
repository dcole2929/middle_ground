defmodule MiddleGroundWeb.ChatLive.Root do
  use MiddleGroundWeb, :live_view

  alias MiddleGround.QuestionChat
  alias MiddleGroundWeb.Endpoint
  alias MiddleGroundWeb.ChatLive.{Chat, Chats, Message}

  def mount(_params, _session, socket) do
    {:ok, socket
    |> assign_chats()
    |> assign_active_chat()
    |> assign_scrolled_to_top()
    |> assign_last_user_message()}
  end

  def handle_params(%{"id" => id}, _uri, %{assigns: %{live_action: :show}} = socket) do
    if connected?(socket), do: Endpoint.subscribe("chat:#{id}")

    {:noreply,
     socket
     |> assign_active_chat(id)
     |> assign_active_chat_messages()
     |> assign_last_user_message()}
  end

  def handle_params(_params, _uri, socket), do: {:noreply, socket}

  def handle_info(%{event: "new_message", payload: %{message: message}}, socket) do
    {:noreply,
     socket
     |> insert_new_message(message)
     |> assign_last_user_message(message)}
  end

  def handle_info(%{event: "updated_message", payload: %{message: message}}, socket) do
    {:noreply,
     socket
     |> insert_updated_message(message)
     |> assign_last_user_message(message)}
  end

  def handle_event("load_more", _params, socket) do
    case socket.assigns.oldest_message_id do
      nil ->
        IO.puts('No messages.')
        {:noreply, socket}
      oldest_message_id ->
        messages = QuestionChat.get_previous_n_messages(oldest_message_id, 5)
        if Enum.empty?(messages) do
          IO.puts("No more messages to load.")
          {:noreply, socket}
        else
          {:noreply,
          socket
          |> stream_batch_insert(:messages, messages, at: 0)
          |> assign_oldest_message_id(List.last(messages))
          |> assign_scrolled_to_top("true")}
        end
      end
  end

  def handle_event("unpin_scrollbar_from_top", _params, socket) do
    {:noreply,
     socket
     |> assign_scrolled_to_top("false")}
  end

  def handle_event("delete_message", %{"item_id" => message_id}, socket) do
    {:noreply, delete_message(socket, message_id)}
  end

  def insert_new_message(socket, message) do
    socket
    |> stream_insert(:messages, QuestionChat.preload_message_user(message))
  end

  def insert_updated_message(socket, message) do
    socket
    |> stream_insert(:messages, QuestionChat.preload_message_user(message), at: -1)
  end

  def assign_active_chat_messages(socket) do
    messages = QuestionChat.last_ten_messages_for(socket.assigns.chat.id)

    # safely get first message
    oldest_message_id = case messages do
      [first_message | _rest] -> first_message.id
      [] -> nil  # Or handle the empty case differently if needed
    end

    socket
    |> stream(:messages, messages)
    |> assign(:oldest_message_id, oldest_message_id)
  end

  def assign_chats(socket) do
    assign(socket, :chats, QuestionChat.list_chats())
  end

  def assign_active_chat(socket, id) do
    assign(socket, :chat, QuestionChat.get_chat!(id))
  end

  def assign_active_chat(socket) do
    assign(socket, :chat, nil)
  end

  def assign_scrolled_to_top(socket, scrolled_to_top \\ "false") do
    assign(socket, :scrolled_to_top, scrolled_to_top)
  end

  def assign_oldest_message_id(socket, message) do
    assign(socket, :oldest_message_id, message.id)
  end

  def assign_is_editing_message(socket, is_editing \\ nil) do
    assign(socket, :is_editing_message, is_editing)
  end

  def assign_last_user_message(%{assigns: %{current_user: current_user}} = socket, message)
      when current_user.id == message.sender_id do
    assign(socket, :message, message)
  end

  def assign_last_user_message(socket, _message) do
    socket
  end

  def assign_last_user_message(%{assigns: %{chat: nil}} = socket) do
    assign(socket, :message, %QuestionChat.Message{})
  end

  def assign_last_user_message(%{assigns: %{chat: chat, current_user: current_user}} = socket) do
    assign(socket, :message, get_last_user_message_for_chat(chat.id, current_user.id))
  end

  def delete_message(socket, message_id) do
    message = QuestionChat.get_message!(message_id)
    QuestionChat.delete_message(message)
    stream_delete(socket, :messages, message)
  end

  def get_last_user_message_for_chat(chat_id, current_user_id) do
    QuestionChat.last_user_message_for_chat(chat_id, current_user_id) || %QuestionChat.Message{}
  end
end
