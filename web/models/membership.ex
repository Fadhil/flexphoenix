defmodule Flexcility.Membership do
  use Flexcility.Web, :model

  schema "memberships" do
    belongs_to :user, Flexcility.User
    belongs_to :organisation, Flexcility.Organisation
    belongs_to :role, Flexcility.Role

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> validate_required([])
  end
end
