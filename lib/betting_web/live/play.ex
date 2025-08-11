defmodule BettingWeb.Live.Play do
  use BettingWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    games = Betting.Games.Game |> Ash.read!()

    {:ok,
     socket
     |> assign(:games, games)}
  end
end
