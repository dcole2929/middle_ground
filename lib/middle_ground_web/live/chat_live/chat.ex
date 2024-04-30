defmodule MiddleGroundWeb.ChatLive.Chat do
  use Phoenix.Component
  alias MiddleGroundWeb.ChatLive.{Messages, Message}

  def show(assigns) do
    ~H"""
    <div id={"chat-#{@chat.id}"}>
      <Messages.list_messages messages={@messages} scrolled_to_top={@scrolled_to_top} />
      <.live_component
        module={Message.Form}
        chat_id={@chat.id}
        user_id={@current_user_id}
        id={"chat-#{@chat.id}-message-form"}
      />
    </div>
    """
  end
end
