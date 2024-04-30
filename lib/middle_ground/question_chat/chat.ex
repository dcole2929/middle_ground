defmodule MiddleGround.QuestionChat.Chat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chats" do
    field :name, :string
    field :question_id, :id
    has_many :messages, MiddleGround.QuestionChat.Message

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(chat, attrs) do
    chat
    |> cast(attrs, [:name, :question_id])
    |> validate_required([:name, :question_id])
  end
end
