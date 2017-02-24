defmodule Flexcility.Facility do
  use Flexcility.Web, :model

  schema "facilities" do
    field :name, :string
    field :icon_name, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :icon_name])
    |> validate_required([:name, :icon_name])
  end
end
