defmodule MiddleGround.Repo do
  use Ecto.Repo,
    otp_app: :middle_ground,
    adapter: Ecto.Adapters.Postgres
end
