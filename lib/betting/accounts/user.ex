defmodule Betting.Accounts.User do
  use Ash.Resource,
    otp_app: :betting,
    domain: Betting.Main,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "users"
    repo Betting.Rep
  end

  actions do
    defaults [:read, :create, :update]
  end

  policies do
    # Must be in same company for anything
    policy always() do
      authorize_if expr(^actor(:company_id) == company_id)
    end

    # Read: self OR admin
    policy action(:read) do
      authorize_if expr(id == ^actor(:id))
      authorize_if expr(^actor(:role) == "admin")
    end

    # Create/update: admin only
    policy action([:create, :update]) do
      authorize_if expr(^actor(:role) == "admin")
    end
  end

  multitenancy do
    strategy :attribute
    attribute :company_id
  end

  attributes do
    # Use uuid_primary_key unless you're sure you want v7
    uuid_primary_key :id

    attribute :username, :string, allow_nil?: false

    attribute :balance, :float do
      default 0
    end

    attribute :role, :string do
      default "user"
    end

    validations do
      validate one_of(:role, in: ["admin", "user"])
    end

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :company, Betting.Accounts.Company, allow_nil?: false
  end

  identities do
    identity :username_in_company, [:company_id, :username]
  end
end
