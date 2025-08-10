defmodule BettingWeb.PageController do
  use BettingWeb, :controller

  def home(conn, _params) do
    IO.inspect(conn.assigns)
    render(conn, :home)
  end
end
