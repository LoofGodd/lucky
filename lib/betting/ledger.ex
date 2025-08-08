defmodule Betting.Ledger do
  use Ash.Domain,
    otp_app: :betting

  resources do
    resource Betting.Ledger.Account
    resource Betting.Ledger.Balance
    resource Betting.Ledger.Transfer
  end
end
