defmodule Betting.Accounts.User do
  use Ash.Resource,
    otp_app: :betting,
    domain: Betting.Main,
    data_layer: AshPostgres.DataLayer

  # authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "users"
    repo Betting.Repo
  end

  actions do
    defaults [:read, :update]

    create :create do
      accept [:username, :role, :balance]
    end
  end

  # policies do
  #
  #   policy action(:read) do
  #     authorize_if expr(id == ^actor(:id))
  #     authorize_if expr(^actor(:role) == "admin")
  #   end
  #
  #   policy action([:create, :update]) do
  #     authorize_if expr(^actor(:role) == "admin")
  #   end
  # end

  multitenancy do
    strategy :attribute
    attribute :company_id
  end

  attributes do
    uuid_primary_key :id
    attribute :username, :string, allow_nil?: false

    attribute :balance, :float do
      default 0
    end

    attribute :role, :string do
      default "user"
    end

    validations do
      validate one_of(:role, ["admin", "user", "moderator"])
    end

    attribute :metadata, :map do
      allow_nil? true
      description "Free-form JSON object"
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
