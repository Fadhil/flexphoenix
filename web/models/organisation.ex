defmodule Flexcility.Organisation do
  use Flexcility.Web, :model

  schema "organisations" do
    field :name, :string
    field :display_name, :string
    field :subdomain
    field :logo, Flexcility.Image.Type
    field :description, :string

    timestamps()

    has_many :memberships, Flexcility.Membership, on_delete: :delete_all
    has_many :users, through: [:memberships, :user]
    has_many :invitations, Flexcility.Invitation, on_delete: :delete_all

    many_to_many :facilities, Flexcility.Facility, join_through: "facilities_organisations"
  end

  @all_fields [:name, :subdomain, :description]
  @image_fields [:logo]
  @required_fields [:name, :subdomain]
  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @all_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:subdomain)
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

  def with_facilities(organisation) do
    organisation |> Repo.preload([:facilities])
  end

  def with_memberships(organisation) do
    organisation |> Repo.preload([{:memberships, [:role, :organisation, {:user, [:profile]}]}])
  end
end
