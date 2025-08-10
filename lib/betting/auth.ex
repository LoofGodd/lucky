defmodule Betting.Auth do
  @salt "login-link-1"

  def sign(%Betting.Accounts.Player{id: id, company_id: company_id}) do
    Phoenix.Token.sign(
      BettingWeb.Endpoint,
      @salt,
      %{sub: to_string(id), tid: company_id, jti: Ecto.UUID.generate()}
    )
  end

  def verify(token, max_age \\ 6000) do
    Phoenix.Token.verify(BettingWeb.Endpoint, @salt, token, max_age: max_age)
  end
end
