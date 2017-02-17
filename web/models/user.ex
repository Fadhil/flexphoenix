defmodule Flexcility.User do
  use Flexcility.Web, :model
  alias Passport.Password

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string

    has_one :profile, Flexcility.Profile
    has_many :memberships, Flexcility.Membership
    has_many :sent_invitations, Flexcility.Invitation, foreign_key: :inviter_id
    has_many :organisations, through: [:memberships, :organisation]
    has_many :roles, through: [:memberships, :role]
    has_many :projects, Flexcility.Project
    has_many :requests, Flexcility.Request
    has_many :orders, Flexcility.Order
    has_many :reports, Flexcility.Report
    has_many :users_roles, Flexcility.UsersRole
    # has_many :roles, through: [:users_roles, :role]
    has_many :attached_projects, through: [:users_roles, :project]
    has_many :assigned_technicians, Flexcility.AssignedTechnician
    has_many :assigned_requests, through: [:assigned_technicians, :request]
    has_many :assigned_orders, through: [:assigned_technicians, :order]
    timestamps
  end

  @required_fields [:first_name, :last_name, :email, :password]
  @all_fields [:first_name, :last_name, :email, :password]

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> validate_format(:email, ~r/@/)
    |> cast_assoc(:profile)
    |> unique_constraint(:email)
  end

  def update_changeset(model, params \\ %{}) do model
    |> cast(params, @all_fields)
    |> cast_assoc(:profile, required: true)
  end

  def registration_changeset(model, params \\ %{}) do model
    |> changeset(params)
    |> validate_length(:password, min: 6, max: 100)
    |> validate_confirmation(:password)
    |> put_hashed_password()
  end

  defp put_hashed_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Password.hash(pass))
        _ ->
          changeset
    end
  end

end
