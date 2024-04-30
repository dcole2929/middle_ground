defmodule MiddleGround.QuestionChat do
  @moduledoc """
  The QuestionChat context.
  """

  import Ecto.Query, warn: false
  alias MiddleGround.Repo

  alias MiddleGround.QuestionChat.Chat
  alias MiddleGround.QuestionChat.Message
  alias MiddleGroundWeb.Endpoint

  @doc """
  Returns the list of chats.

  ## Examples

      iex> list_chats()
      [%Chat{}, ...]

  """
  def list_chats do
    Repo.all(Chat)
  end

  @doc """
  Gets a single chat.

  Raises `Ecto.NoResultsError` if the Chat does not exist.

  ## Examples

      iex> get_chat!(123)
      %Chat{}

      iex> get_chat!(456)
      ** (Ecto.NoResultsError)

  """
  def get_chat!(id), do: Repo.get!(Chat, id)

  def get_chat_by_question_id(question_id) do
    query = from c in Chat, where: c.question_id == ^question_id, select: c
    Repo.one(query)
  end

  @doc """
  Creates a chat.

  ## Examples

      iex> create_chat(%{field: value})
      {:ok, %Chat{}}

      iex> create_chat(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_chat(attrs \\ %{}) do
    %Chat{}
    |> Chat.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a chat.

  ## Examples

      iex> update_chat(chat, %{field: new_value})
      {:ok, %Chat{}}

      iex> update_chat(chat, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_chat(%Chat{} = chat, attrs) do
    chat
    |> Chat.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a chat.

  ## Examples

      iex> delete_chat(chat)
      {:ok, %Chat{}}

      iex> delete_chat(chat)
      {:error, %Ecto.Changeset{}}

  """
  def delete_chat(%Chat{} = chat) do
    Repo.delete(chat)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking chat changes.

  ## Examples

      iex> change_chat(chat)
      %Ecto.Changeset{data: %Chat{}}

  """
  def change_chat(%Chat{} = chat, attrs \\ %{}) do
    Chat.changeset(chat, attrs)
  end

  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """
  def list_messages(chat_id) do
    from(m in Message,
      where: m.chat_id == ^chat_id,
      order_by: [desc: m.inserted_at],
      preload: [:user]
    )
    |> Repo.all()
  end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Chat does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(id), do: Repo.get!(Message, id)

  def last_ten_messages_for(chat_id) do
    Message.Query.for_chat(chat_id)
    |> Repo.all()
    |> Repo.preload(:user)
  end

  def last_user_message_for_chat(chat_id, user_id) do
    Message.Query.last_user_message_for_chat(chat_id, user_id)
    |> Repo.one()
  end

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

@doc """
  Updates a message.

  ## Examples

      iex> update_message(chat, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(chat, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a message.

  ## Examples

      iex> delete_message(chat)
      {:ok, %Message{}}

      iex> delete_message(chat)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message) do
    Repo.delete!(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(chat)
      %Ecto.Changeset{data: %Message{}}

  """
  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end

  defstruct message_content: nil, chat_id: nil, user_id: nil

  def preload_message_user(message) do
    message
    |> Repo.preload(:user)
  end

  def publish_message_created({:ok, message} = result) do
    Endpoint.broadcast("chat:#{message.chat_id}", "new_message", %{message: message})
    result
  end

  def publish_message_created(result), do: result

  def publish_message_updated({:ok, message} = result) do
    Endpoint.broadcast("chat:#{message.chat_id}", "updated_message", %{message: message})
    result
  end

  def publish_message_updated(result), do: result

  def get_previous_n_messages(id, n) do
    Message.Query.previous_n(id, n)
    |> Repo.all()
    |> Repo.preload(:user)
  end

end
