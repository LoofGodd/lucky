defmodule Betting.Ledger.Transfer do
  use Ash.Resource,
    domain: Elixir.Betting.Ledger,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshDoubleEntry.Transfer]

  transfer do
    account_resource Betting.Ledger.Account
    balance_resource Betting.Ledger.Balance
  end

  postgres do
    table "ledger_transfers"
    repo Betting.Repo
  end

  actions do
    defaults [:read]

    create :transfer do
      accept [:amount, :timestamp, :from_account_id, :to_account_id]
    end
  end

  attributes do
    attribute :id, AshDoubleEntry.ULID do
      primary_key? true
      allow_nil? false
      default &AshDoubleEntry.ULID.generate/0
    end

    attribute :amount, :money do
      allow_nil? false
    end

    timestamps()
  end

  relationships do
    belongs_to :from_account, Betting.Ledger.Account do
      attribute_writable? true
    end

    belongs_to :to_account, Betting.Ledger.Account do
      attribute_writable? true
    end

    has_many :balances, Betting.Ledger.Balance
  end
end
