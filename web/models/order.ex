defmodule Flexphoenix.Order do
  use Flexphoenix.Web, :model

  schema "orders" do
    field :title, :string
    field :body, :string

    belongs_to :user, Flexphoenix.User
    timestamps
  end

  @required_fields ~w(title body)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def create_changeset(model, user_id, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> put_user_id(user_id)
  end

  def put_user_id(changeset, user_id) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        put_change(changeset, :user_id, user_id)
      _ ->
        changeset
    end
  end

  def with_owner(query) do
    from q in query, preload: [:user]
  end

end