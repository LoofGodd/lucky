defmodule BettingWeb.LoginController do
  use BettingWeb, :controller
  alias Betting.{Auth, Accounts}

  def partner_user_login(conn, %{"company" => company, "username" => username}) do
    with {:ok, _company} <- Accounts.get_companry_by_id(company),
         {:ok, user} <- Accounts.get_user_by_username(username, company) do
      token = Auth.sign(user)
      url = url(~p"/user/playing?token=#{token}")
      json(conn, %{ok: true, url: url})
    else
      _ -> json(conn, %{ok: false, error: "Invalide credentials"})
    end
  end

  def partner_user_login(conn, _params) do
    json(conn, %{ok: false, error: "company and username are required"})
  end
end
