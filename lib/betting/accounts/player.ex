defmodule Betting.Accounts.Player do
  use Ash.Resource,
    otp_app: :betting,
    domain: Betting.Main,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "players"
    repo Betting.Repo
  end

  actions do
    defaults [:read]

    create :create do
      accept [:username, :role, :metadata]
    end
  end

  multitenancy do
    strategy :attribute
    attribute :company_id
  end

  attributes do
    uuid_primary_key :id

    attribute :username, :string

    attribute :role, :string do
      default "user"
    end

    attribute :status, :string do
      default "active"
    end

    attribute :risk_level, :string do
      default "low"
    end

    attribute :metadata, :map do
      allow_nil? true
    end

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :company, Betting.Accounts.Company
  end

  identities do
    identity :unique_username_companry, [:username, :company_id]
  end
end
