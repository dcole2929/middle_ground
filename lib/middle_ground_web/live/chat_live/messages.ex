defmodule MiddleGroundWeb.ChatLive.Messages do
  use MiddleGroundWeb, :html
  import MiddleGroundWeb.CustomComponents

  def list_messages(assigns) do
    ~H"""
    <div
      id="messages"
      phx-update="stream"
      class="overflow-scroll"
      style="height: calc(88vh - 10rem)"
      phx-hook="ScrollDown"
      data-scrolled-to-top={@scrolled_to_top}
    >
      <div id="infinite-scroll-marker" phx-hook="InfiniteScroll"></div>
      <%= if Enum.count(@messages) == 0 do %>
        <div class="mt-2 text-gray-500 text-center">
          No Messages Yet! Be the first to add to the conversation!
        </div>
      <% else %>
        <div
          :for={{dom_id, message} <- @messages}
          id={dom_id}
          class="mt-2 hover:bg-gray-100 messages"
          phx-hook="Hover"
          data-toggle={JS.toggle(to: "#message-#{message.id}-buttons")}
        >
          <.message_details message={message} />
        </div>
      <% end %>
    </div>
    """
  end

  def message_details(assigns) do
    ~H"""
    <.message_meta message={@message} />
    <.message_content message={@message} />
    """
  end

  def message_meta(assigns) do
    ~H"""
    <dl class="-my-4 divide-y divide-zinc-100">
      <div class="flex gap-4 py-4 sm:gap-2">
        <.user_icon />
        <dt class="w-1/8 flex-none text-[0.9rem] leading-8 text-zinc-500" style="font-weight: 900">
          <%= @message.user.email %>
          <span style="font-weight: 300">[<%= @message.inserted_at %>]</span>
          <.delete_icon id={"message-#{@message.id}-buttons"} phx_click="delete_message" value={@message.id} />
        </dt>
      </div>
    </dl>
    """
  end

  def message_content(assigns) do
    ~H"""
    <dl class="-my-4 divide-y divide-zinc-100">
      <div class="flex gap-4 py-4 sm:gap-2">
        <dd class="text-sm leading-10 text-zinc-700" style="margin-left: 3%;margin-top: -1%;">
          <%= @message.message_content %>
        </dd>
      </div>
    </dl>
    """
  end
end
