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
alias Betting.Accounts.{Company, User}

# 1. Insert a company
Company
|> Ash.Changeset.for_create(:create, %{
  name: "ISK",
  slug: "isk",
  url: "example.com"
})
|> Ash.create!()

User
|> Ash.Changeset.for_create(:register_with_password, %{
  email: "love@example.com",
  role: "admin",
  password: "123456789qwertyu",
  password_confirmation: "123456789qwertyu"
})
|> Ash.create!()

IO.puts("✅ Seed data inserted: company + 1 users")
