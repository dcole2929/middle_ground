defmodule MiddleGround.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :role_name, :string

      timestamps(type: :utc_datetime)
    end
  end
end
