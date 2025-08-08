defmodule Betting.Auth do
  @salt "login-link-1"

  def sign(%{id: id}) when is_integer(id) do
    Phoenix.Token.sign(BettingWeb.Endpoint, @salt, %{sub: id, jti: Ecto.UUID.generate()})
  end

  def verify(token, max_age \\ 6000) do
    Phoenix.Token.verify(MyAppWeb.Endpoint, @salt, token, max_age: max_age)
  end
end
