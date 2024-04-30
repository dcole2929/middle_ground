defmodule MiddleGround.Question do
  use Ecto.Schema
  import Ecto.Changeset

  alias MiddleGround.Repo
  alias MiddleGround.Question

  schema "questions" do
    field :text, :string
    has_many :responses, MiddleGround.Response
    timestamps(type: :utc_datetime)
  end

  def list_questions do
    Repo.all(Question)
  end

  def get_question!(id) do
    Repo.get!(Question, id)
  end

  def create_question(attrs \\ %{}) do
    IO.puts("Creating question, " <> inspect(attrs))
    %Question{}
    |> Question.changeset(attrs)
    |> Repo.insert()
  end

  def update_question(%Question{} = question, attrs) do
    question
    |> Question.changeset(attrs)
    |> Repo.update()
  end

  def delete_question(%Question{} = question) do
    Repo.delete(question)
  end

  def change_question(%Question{} = question, attrs \\ %{}) do
    question
    |>Question.changeset(attrs)
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:text])
    |> validate_required([:text])
  end
end
