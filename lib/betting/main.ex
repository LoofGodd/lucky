defmodule Betting.Main do
  use Ash.Domain,
    otp_app: :betting,
    extensions: [AshAdmin.Domain]

  resources do
    resource Betting.Accounts.User
    resource Betting.Accounts.Company
  end
end
