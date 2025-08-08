defmodule BettingWeb.UserController do
  use BettingWeb, :controller

  def show(conn, _params) do
    case conn.assigns[:current_user] do
      nil -> json(conn, %{error: "unauthorized"})
      u -> json(conn, u)
    end
  end
end
