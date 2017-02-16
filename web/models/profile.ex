defmodule Flexcility.Profile do
  use Flexcility.Web, :model

  @all_fields [:full_name, :image]
  schema "profiles" do
    field :full_name, :string
    field :image, :string
    belongs_to :user, Flexcility.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @all_fields)
    |> validate_required(@required_fields)
  end
end
