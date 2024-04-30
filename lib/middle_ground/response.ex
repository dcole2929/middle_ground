defmodule MiddleGround.Response do
  use Ecto.Schema
  import Ecto.Changeset

  alias MiddleGround.Repo
  alias MiddleGround.Response
  alias MiddleGround.Question
  alias MiddleGround.Accounts.User


  schema "responses" do
    field :response_type, :string

    belongs_to :question, Question
    belongs_to :user, User  # this was added

    timestamps(type: :utc_datetime)
  end

  # Retrieve all responses
  def list_responses do
    Repo.all(Response)
    |> Repo.preload([:question, :user])
  end

  # Retrieve a response by ID
  def get_response(id) do
    Repo.get(Response, id)
    |> Repo.preload([:question, :user])
  end

  # Create a response
  def create_response(attrs \\ %{}) do
    IO.puts("attrs: #{inspect(attrs)}")
    user = Repo.get(User, attrs["user_id"])
    question = Repo.get(Question, attrs["question_id"])

    if question && user do
      %Response{}
      |> Response.changeset(attrs)
      |> Repo.insert()
    else
      {:error, "Invalid question or user"}
    end
  end

  # Update a response
  def update_response(id, attrs) do
    response = Repo.get(Response, id)
    response
    |> Response.changeset(attrs)
    |> Repo.update()
  end

  # Delete a response
  def delete_response(id) do
    response = Repo.get(Response, id)
    Repo.delete(response)
  end

  @doc false
  def changeset(response, attrs) do
    response
    |> cast(attrs, [:response_type, :question_id, :user_id])
    |> validate_required([:response_type, :question_id, :user_id])
    |> validate_inclusion(:response_type, ["strongly agree", "agree", "neutral", "disagree", "strongly disagree"])
  end
end
