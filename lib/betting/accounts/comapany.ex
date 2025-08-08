defmodule Betting.Accounts.Company do
  use Ash.Resource,
    otp_app: :betting,
    data_layer: AshPostgres.DataLayer,
    domain: Betting.Main,
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "campanies"
    repo Betting.Repo
  end

  actions do
    defaults [:read, :create, :update]
  end

  policies do
    policy action([[:read, :update, :create]]) do
      authorize_if expr(^actor(:company_id) == id and ^actor(:role) == "admin")
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
    end

    attribute :slug, :string do
      allow_nil? false
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
