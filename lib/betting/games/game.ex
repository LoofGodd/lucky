defmodule Betting.Games.Game do
  use Ash.Resource,
    otp_app: :betting,
    domain: Betting.Games,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "games"
    repo Betting.Repo
  end

  actions do
    defaults [:read]

    create :create do
      accept [:title, :slug, :description, :status, :image]
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :title, :string do
      allow_nil? false
    end

    attribute :slug, :string do
      allow_nil? false
    end

    attribute :description, :string

    attribute :status, :string do
      default "soon"
    end

    attribute :image, :string
  end
end
