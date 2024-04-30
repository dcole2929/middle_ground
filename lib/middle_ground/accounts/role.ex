defmodule MiddleGround.Accounts.Role do
  use Ecto.Schema
  import Ecto.Changeset
  alias MiddleGround.Accounts.User

  schema "roles" do
    field :role_name, :string
    many_to_many :users, User, join_through: "user_roles"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:role_name])
    |> validate_required([:role_name])
  end
end
