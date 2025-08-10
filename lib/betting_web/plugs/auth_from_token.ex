defmodule BettingWeb.Plugs.AuthFromToken do
  import Plug.Conn
  alias Ash.PlugHelpers
  alias Betting.Auth

  def init(opts), do: opts

  def call(%Plug.Conn{params: %{"token" => token}} = conn, _opts) do
    with {:ok, id} <- Auth.verify(token),
         {:ok, %Betting.Accounts.Player{} = user} <- get_user(id) do
      user = Map.drop(Map.from_struct(user), [:__meta__, :company])
      IO.inspect("FUCK")

      conn
      |> configure_session(renew: true)
      |> put_session(:user_id, user.id)
      |> PlugHelpers.set_actor(user)
      |> assign(:current_user, user)
    else
      _ -> conn
    end
  end

  def call(conn, _), do: conn

  defp get_user(%{sub: id, tid: company_id}) do
    Ash.get(Betting.Accounts.Player, id, tenant: company_id)
  end
end
