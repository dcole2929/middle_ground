# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     MiddleGround.Repo.insert!(%MiddleGround.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
defmodule MiddleGround.Seeds do
  alias MiddleGround.Repo
  alias MiddleGround.Accounts.Role
  alias MiddleGround.Accounts

  # Function to insert roles if they don't exist
  defp seed_roles do
    Enum.each(["user", "admin"], fn role_name ->
      case Repo.get_by(Role, role_name: role_name) do
        nil ->
          Repo.insert!(%Role{role_name: role_name})
          IO.puts("Inserted or updated role: #{role_name}")
        _role -> IO.puts("Role already exists: #{role_name}")
      end
    end)
  end

  # Function to create an admin user
  defp create_admin_user do
    password = "middleground_password123"

    user_params = %{
      "email" => "admin@middleground.test",
      "password" => password,
    }

    case Accounts.register_user(user_params, ["admin"]) do
      {:ok, user} -> IO.puts("Admin user created successfully: #{user.email}")
      {:error, changeset} -> IO.puts("Failed to create admin user: #{inspect(changeset.errors)}")
    end
  end

  # Seed roles and create an admin user
  def seed_data do
    seed_roles()
    create_admin_user()
  end
end

# Run the seed data function
MiddleGround.Seeds.seed_data()
