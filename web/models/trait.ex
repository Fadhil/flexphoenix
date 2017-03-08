defmodule Flexcility.Trait do
  use Flexcility.Web, :model

  schema "traits" do
    field :name, :string
    field :code, :string
    field :abbreviation, :string

    timestamps()

    many_to_many :organisations, Flexcility.Organisation, join_through: "organisations_traits"
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :code, :abbreviation])
    |> validate_required([:name, :code, :abbreviation])
  end
end
