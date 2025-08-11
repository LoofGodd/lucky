defmodule Betting.Main do
  use Ash.Domain,
    otp_app: :betting

  resources do
    resource Betting.Accounts.User
    resource Betting.Accounts.Player
    resource Betting.Accounts.Token
    resource Betting.Accounts.Company
  end
end
