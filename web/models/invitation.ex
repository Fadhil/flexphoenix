defmodule Flexcility.Invitation do
  use Flexcility.Web, :model
  alias Flexcility.Utils

  @all_fields [
    :role_id, :organisation_id, :organisation_subdomain, :inviter_id, :invitee_email, :accepted,
    :viewed
  ]

  @required_fields [
    :role_id, :organisation_subdomain, :inviter_id, :invitee_email
  ]

  schema "invitations" do
    field :key, :string
    field :invitee_email, :string
    field :accepted, :boolean, default: false
    field :viewed, :boolean, default: false
    field :organisation_subdomain, :string
    belongs_to :organisation, Flexcility.Organisation
    belongs_to :inviter, Flexcility.User
    belongs_to :role, Flexcility.Role

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @all_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:invitee_email, name: :unique_invite)
    |> generate_invite_key
  end

  defp generate_invite_key(changeset) do
    changeset
    |> put_change(:key, Utils.String.random(32))
  end
end
