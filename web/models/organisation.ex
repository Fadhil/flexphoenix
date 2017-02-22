defmodule Flexcility.Organisation do
  use Flexcility.Web, :model
  alias Flexcility.Repo

  schema "organisations" do
    field :name, :string
    field :display_name, :string
    field :logo, Flexcility.Image.Type
    field :description, :string

    timestamps()

    has_many :memberships, Flexcility.Membership, on_delete: :delete_all
    has_many :users, through: [:memberships, :user]
    has_many :invitations, Flexcility.Invitation, on_delete: :delete_all
  end

  @all_fields [:name, :display_name, :description]
  @image_fields [:logo]
  @required_fields [:name, :display_name]
  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @all_fields)
    |> validate_required(@required_fields)
    |> cast_attachments(params, @image_fields)
  end

  def create_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @all_fields)
    |> validate_required(@required_fields)
  end

  def image_changeset(organisation, params) do
    organisation
    |> cast_attachments(params, @image_fields)
  end

  def get_members_roles(membership) do
    %{role: %{name: role}, user: %{email: email, profile: %{image: image} = profile}} = membership
    %{email: email, role: role, profile: profile}
  end

  def get_members(organisation) do
    case organisation.memberships do
      [] ->
        []
      memberships when is_list(memberships) ->
        memberships
        |> Enum.map(&get_members_roles/1)
        |> Enum.group_by(&(&1.role))
    end
  end
end
