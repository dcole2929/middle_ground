defmodule MiddleGround.QuestionChat.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias MiddleGround.QuestionChat.Chat
  alias MiddleGround.Accounts.User

  schema "messages" do
    field :message_content, :string
    belongs_to :chat, Chat
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:message_content, :chat_id, :user_id])
    |> validate_required([:message_content, :chat_id, :user_id])
  end
end
