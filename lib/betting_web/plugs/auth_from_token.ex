defmodule BettingWeb.Plugs.AuthFromToken do
  import Plug.Conn
  alias Ash.PlugHelpers
  alias Betting.Auth

  def init(opts), do: opts

  def call(%Plug.Conn{params: %{"token" => token}} = conn, _opts) do
    with {:ok, id} <- Auth.verify(token),
         {:ok, user} <- get_user(id) do
      conn
      |> configure_session(renew: true)
      |> put_session(:user_id, id)
      |> PlugHelpers.set_actor(user)
      |> assign(:current_user, user)
    else
      _ -> conn
    end
  end

  def call(conn, _), do: conn

  defp get_user(id) do
    Betting.Main |> Ash.get(Betting.Accounts.User, id)
  end
end
