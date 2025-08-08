defmodule Betting.Accounts do
  alias Betting.Accounts.{Company, User}

  def get_companry_by_slug(slug) do
    case Company |> Ash.read!(filter: [slug: slug]) do
      [c] -> {:ok, c}
      _ -> :error
    end
  end

  def get_companry_by_id(id) do
    case Company |> Ash.read!(filter: [id: id]) do
      [c] -> {:ok, c}
      _ -> :error
    end
  end

  def get_user_by_username(username) do
    case User |> Ash.read!(filter: [username: username]) do
      [u] -> {:ok, u}
      _ -> :error
    end
  end

  def verify_companry(id) do
    case Company |> Ash.read!(filter: [id: id]) do
      [_c] -> true
      _ -> false
    end
  end
end
