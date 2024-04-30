# lib/my_app_web/ensure_role_plug.ex
defmodule MiddleGroundWeb.AccessControlPlug do
  @moduledoc """
  This plug ensures that a user has a particular role.

  ## Example

      plug MiddleGroundWeb.AccessControlPlug, [:user, :admin]

      plug MiddleGroundWeb.AccessControlPlug, :admin

      plug MiddleGroundWeb.AccessControlPlug, ~w(user admin)a
  """
  import Plug.Conn, only: [halt: 1]

  use MiddleGroundWeb, :verified_routes

  alias Phoenix.Controller
  alias Plug.Conn
  alias MiddleGround.Repo
  alias MiddleGround.Accounts.User
  import Ecto.Query

  @doc false
  @spec init(any()) :: any()
  def init(config), do: config

  defp current_user_with_roles(conn) do
    user = Map.get(conn.assigns, :current_user)
    Repo.one(from u in User, preload: [:roles], where: u.id == ^user.id)
  end

  @doc false
  @spec call(Conn.t(), atom() | binary() | [atom()] | [binary()]) :: Conn.t()
  def call(conn, roles) do

    current_user = current_user_with_roles(conn)
    IO.puts("current_user: #{inspect(current_user)}")
    case current_user do
      nil -> maybe_halt(true, conn)
      current_user ->
        current_user
        |> has_role?(roles)
        |> maybe_halt(conn)
    end

  end

  defp has_role?(nil, _roles), do: false
  defp has_role?(_user, []), do: false

  defp has_role?(user, roles) when is_list(roles) do
    Enum.any?(roles, &has_role?(user, &1))
  end

  defp has_role?(user, role) when is_atom(role) do
    has_role?(user, Atom.to_string(role))
  end

  defp has_role?(%User{} = user, role) do
    IO.puts('in user has_role')

    Enum.any?(user.roles, &(&1.role_name == role))

  end

  defp has_role?(_user, _role), do: false

  defp maybe_halt(true, conn), do: conn
  defp maybe_halt(_any, conn) do
    conn
    |> Controller.put_flash(:error, "Unauthorized access")
    |> Controller.redirect(to: ~p"/")
    |> halt()
  end
end
