defmodule Flexcility.Trait do
  use Flexcility.Web, :model

  schema "traits" do
    field :name, :string
    field :code, :string
    field :abbreviation, :string

    timestamps()

    many_to_many :organisations, Flexcility.Organisation, join_through: "organisations_traits"
    many_to_many :sites, Flexcility.Site, join_through: "sites_traits"
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :code, :abbreviation])
    |> validate_required([:name, :code, :abbreviation])
  end

  @doc """
  Returns a list of Trait structs matching the list of ids given.
  """
  def all(ids) do
    query = from t in Flexcility.Trait,
      where: t.id in ^ids
    Repo.all(query)
  end
end
