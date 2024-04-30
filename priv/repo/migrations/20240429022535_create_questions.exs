defmodule MiddleGround.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :text, :string

      timestamps(type: :utc_datetime)
    end
  end
end
