defmodule Betting.Secrets do
  use AshAuthentication.Secret

  def secret_for(
        [:authentication, :tokens, :signing_secret],
        Betting.Accounts.User,
        _opts,
        _context
      ) do
    Application.fetch_env(:betting, :token_signing_secret)
  end
end
