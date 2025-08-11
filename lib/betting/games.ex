defmodule Betting.Games do
  use Ash.Domain,
    otp_app: :betting

  resources do
    resource Betting.Games.Game
  end
end
