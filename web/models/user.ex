defmodule Flexphoenix.User do
  use Flexphoenix.Web, :model
  alias Passport.Password

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string

    has_many :projects, Flexphoenix.Project
    has_many :requests, Flexphoenix.Request
    has_many :orders, Flexphoenix.Order
    timestamps
  end

  @required_fields ~w(first_name last_name email password)
  @optional_fields ~w()

  def changeset(model, params \\ %{}) do model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

  def registration_changeset(model, params \\ %{}) do model
    |> changeset(params)
    |> cast(params, ~w(password password_confirmation), [])
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
