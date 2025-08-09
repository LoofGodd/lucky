defmodule Betting.Accounts.Company do
  use Ash.Resource,
    otp_app: :betting,
    data_layer: AshPostgres.DataLayer,
    domain: Betting.Main

  postgres do
    table "campanies"
    repo Betting.Repo
  end

  actions do
    defaults [:read, :create, :update]
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
    end

    attribute :slug, :string do
      allow_nil? false
    end

    attribute :url, :string do
      allow_nil? true
    end

    attribute :metadata, :map do
      allow_nil? true
      description "Free-form JSON object"
    end

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  relationships do
    has_many :users, Betting.Accounts.User
  end

  identities do
    identity :slug, [:slug]
  end
end
