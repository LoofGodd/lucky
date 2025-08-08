# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Betting.Repo.insert!(%Betting.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
#
alias Betting.Repo
alias Betting.Accounts.{Company, User}

# 1. Insert a company
company =
  %Company{
    id: Ash.UUID.generate(),
    name: "Demo Company",
    slug: "demo-comapany"
  }
  |> Repo.insert!()

# 2. Insert an admin user for that company
%User{
  id: Ash.UUID.generate(),
  username: "admin",
  role: "admin",
  company_id: company.id
}
|> Repo.insert!()

# 3. Insert a normal user
%User{
  id: Ash.UUID.generate(),
  username: "johndoe",
  role: "user",
  company_id: company.id
}
|> Repo.insert!()

IO.puts("✅ Seed data inserted: company + 2 users")
