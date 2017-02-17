defmodule Flexcility.Invitation do
  use Flexcility.Web, :model

  schema "invitations" do
    field :role_id, :integer
    field :accepted, :boolean, default: false
    field :viewed, :boolean, default: false
    belongs_to :organisation, Flexcility.Organisation
    belongs_to :inviter, Flexcility.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:role_id, :organisation_id, :inviter_id])
    |> validate_required([:role_id, :organisation_id, :inviter_id])
  end
end
