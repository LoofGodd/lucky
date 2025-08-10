defmodule Betting.Accounts do
  alias Betting.Accounts.{Company, Player}

  require Ash.Query

  def get_companry_by_slug(slug) do
    case Company
         |> Ash.Query.filter(slug: slug)
         |> Ash.read_one!() do
      c -> {:ok, c}
    end
  end

  def get_companry_by_id(id) do
    case Company
         |> Ash.Query.filter(id: id)
         |> Ash.read_one!() do
      c -> {:ok, c}
    end
  end

  def get_user_by_username(username, company_id) do
    query =
      Player
      |> Ash.Query.filter(username == ^username)

    case Ash.read_one(query, tenant: company_id) do
      {:ok, nil} ->
        params = %{username: username}

        Player
        |> Ash.Changeset.for_create(:create, params)
        |> Ash.create(tenant: company_id)

      {:ok, user} ->
        {:ok, user}

      {:error, err} ->
        {:error, err}
    end
  end
end
