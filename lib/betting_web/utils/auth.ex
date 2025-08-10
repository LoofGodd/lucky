defmodule BettingWeb.Auth do
  import Phoenix.LiveView
  import Phoenix.Component
  alias Betting.Auth
  alias Betting.Accounts.User

  def on_mount(:fetch_user, params, session, socket) do
    token = params["token"] || session["user_token"]

    case verify_and_load(token) do
      {:ok, user} ->
        {:cont, assign(socket, current_user: user, actor: user)}

      _ ->
        {:cont, assign(socket, current_user: nil, actor: nil)}
    end
  end

  def on_mount(:ensure_authed, _params, _session, socket) do
    if socket.assigns[:current_user] do
      {:cont, socket}
    else
      {
        :halt,
        socket
        |> put_flash(:error, "you must be signed in to view this page.")
        |> redirect(to: "/auth/register")
      }
    end
  end

  defp verify_and_load(nil), do: :error

  defp verify_and_load(token) do
    with {:ok, %{sub: id, tid: company_id}} <- Auth.verify(token),
         {:ok, %User{} = user} <- Ash.get(User, id, tenant: company_id) do
      {:ok, user |> Map.from_struct() |> Map.drop([:__meta__, :company])}
    end
  end
end
