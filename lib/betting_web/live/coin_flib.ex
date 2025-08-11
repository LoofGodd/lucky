defmodule BettingWeb.Live.CoinFlib do
  use BettingWeb, :live_view
  import Bitwise

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:is_flipping, false)
     |> assign(:result, nil)
     |> assign(:heads, 0)
     |> assign(:tails, 0)
     |> assign(:face, 0)
     |> assign(:target_result, nil)}
  end

  @impl true
  def handle_event("flip", _params, %{assigns: %{is_flipping: true}} = socket) do
    # Ignore if already flipping
    {:noreply, socket}
  end

  def handle_event("flip", _params, socket) do
    # Crypto-strong randomness on the server
    <<byte>> = :crypto.strong_rand_bytes(1)
    is_heads = band(byte, 1) == 1
    face = if is_heads, do: 0, else: 180

    # Spin and duration (client will skip if prefers-reduced-motion)
    spins = Enum.random(6..20)

    base = 900
    jitter = Enum.random(0..400)
    duration = base + jitter + spins * 50

    socket =
      socket
      |> assign(:is_flipping, true)
      |> assign(:target_result, if(is_heads, do: :heads, else: :tails))
      |> assign(:face, face)
      |> push_event("animate_coin", %{spins: spins, face: face, duration: duration})

    {:noreply, socket}
  end

  def handle_event("flip_done", _params, %{assigns: %{target_result: tr}} = socket) do
    is_heads = tr == :heads

    socket =
      socket
      |> assign(:is_flipping, false)
      |> assign(:result, if(is_heads, do: "Heads", else: "Tails"))
      |> assign(:heads, socket.assigns.heads + if(is_heads, do: 1, else: 0))
      |> assign(:tails, socket.assigns.tails + if(is_heads, do: 0, else: 1))
      |> assign(:target_result, nil)

    {:noreply, socket}
  end

  def handle_event("reset", _params, socket) do
    socket =
      socket
      |> assign(:result, nil)
      |> assign(:heads, 0)
      |> assign(:tails, 0)
      |> push_event("reset_coin", %{})

    {:noreply, socket}
  end
end
