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

games = [
  %{
    slug: "heads-or-tails",
    title: "Heads or Tails",
    description: "Flip a fair coin with crisp 3D animation.",
    status: :available,
    image: "https://eu.ui-avatars.com/api/?name=heads-or-tails&size=250"
  },
  %{
    slug: "rock-paper-scissors",
    title: "Rock Paper Scissors",
    description: "Classic duel. Challenge a friend or CPU.",
    status: :soon,
    image: "https://eu.ui-avatars.com/api/?name=rock-paper-scissors&size=250"
  },
  %{
    slug: "dice-roll",
    title: "Dice Roll",
    description: "Roll single or multiple dice with realism.",
    status: :soon,
    image: "https://eu.ui-avatars.com/api/?name=dice-roll&size=250"
  },
  %{
    slug: "memory",
    title: "Memory Match",
    description: "Flip cards and test your recall.",
    status: :soon,
    image: "https://eu.ui-avatars.com/api/?name=memory&size=250"
  },
  %{
    slug: "mines",
    title: "Mines",
    description: "Flag wisely and avoid hidden mines.",
    status: :soon,
    image: "https://eu.ui-avatars.com/api/?name=mine&size=250"
  },
  %{
    slug: "tic-tac-toe",
    title: "Tic Tac Toe",
    description: "Perfect AI and local multiplayer.",
    status: :soon,
    image: "https://eu.ui-avatars.com/api/?name=tic-tac-toe&size=250"
  },
  %{
    slug: "2048",
    title: "2048",
    description: "Slide and merge your way to 2048.",
    status: :soon,
    image: "https://eu.ui-avatars.com/api/?name=2048&size=250"
  },
  %{
    slug: "space-runner",
    title: "Space Runner",
    description: "Dodge obstacles in endless space.",
    status: :soon,
    image: "https://eu.ui-avatars.com/api/?name=space-runner&size=250"
  }
]

Ash.bulk_create(games, Betting.Games.Game, :create)

IO.puts("✅ Seed successfully")
