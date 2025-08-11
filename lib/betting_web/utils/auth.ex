# lib/betting_web/live/auth_hooks.ex
defmodule BettingWeb.Utils.Auth do
  import Phoenix.LiveView
  import Phoenix.Component

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

  def on_mount(:ensure_player, params, session, socket) do
    IO.inspect({session["current_user"], params["token"]}, label: "testing")

    if(params["token"] == nil) do
      {:halt,
       socket
       |> put_flash(:error, "user access required.")
       |> redirect(to: "/register")}
    else
      case session["current_user"] do
        %{role: "player"} ->
          {:cont,
           socket
           |> assign(:current_user, session[:current_user])
           |> assign(:token, params["token"])}

        _ ->
          {:halt,
           socket
           |> put_flash(:error, "user access required.")
           |> redirect(to: "/register")}
      end
    end
  end
end
