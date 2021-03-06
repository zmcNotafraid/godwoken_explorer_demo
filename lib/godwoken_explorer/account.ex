defmodule GodwokenExplorer.Account do
  use GodwokenExplorer, :schema

  import Ecto.Changeset

  @primary_key {:id, :integer, autogenerate: false}
  schema "accounts" do
    field :ckb_address, :binary
    field :eth_address, :binary
    field :script_hash, :binary
    field :script, :map
    field :nonce, :integer
    field :type, Ecto.Enum, values: [:meta_contract, :udt, :user, :polyjuice_root, :polyjuice_contract]
    field :layer2_tx, :binary
    has_many :account_udts, GodwokenExplorer.AccountUDT

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:id, :ckb_address, :eth_address, :script_hash, :script, :nonce, :type, :layer2_tx])
    |> validate_required([:id, :script_hash, :script, :nonce, :type])
  end

  def create_or_update_account(attrs) do
    case Repo.get(__MODULE__, attrs[:id]) do
      nil -> %__MODULE__{}
      account -> account
    end
    |> changeset(attrs)
    |> Repo.insert_or_update()
    |> case do
      {:ok, account} -> {:ok, account}
      {:error, _} -> {:error, nil}
    end
  end

end
