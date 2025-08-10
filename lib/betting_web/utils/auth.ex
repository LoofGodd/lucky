# lib/betting_web/live/auth_hooks.ex
defmodule BettingWeb.Live.AuthHooks do
  import Phoenix.LiveView

  def on_mount(:ensure_authed, _params, _session, socket) do
    if socket.assigns[:current_user] do
      {:cont, socket}
    else
      {:halt,
       socket
       |> put_flash(:error, "you must be signed in to view this page.")
       |> redirect(to: "/register")}
    end
  end

  def on_mount(:ensure_admin, _params, _session, socket) do
    case socket.assigns[:current_user] do
      %{role: "admin"} ->
        {:cont, socket}

      _ ->
        {:halt,
         socket
         |> put_flash(:error, "admin access required.")
         |> redirect(to: "/register")}
    end
  end

  def on_mount(:ensure_player, _params, _session, socket) do
    case socket.assigns[:current_user] do
      %{role: "player"} ->
        {:cont, socket}

      _ ->
        {:halt,
         socket
         |> put_flash(:error, "user access required.")
         |> redirect(to: "/register")}
    end
  end
end
