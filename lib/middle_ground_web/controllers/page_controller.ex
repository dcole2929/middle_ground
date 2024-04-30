defmodule MiddleGroundWeb.PageController do
  use MiddleGroundWeb, :controller
  alias MiddleGround.Question

  def index(conn, _params) do
    render(conn, "index.html", questions: Question.list_questions())
  end
end
