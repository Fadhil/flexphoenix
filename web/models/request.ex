defmodule Flexphoenix.Request do
  use Flexphoenix.Web, :model

  schema "requests" do
    field :worktype, :string
    field :title, :string
    field :location, :string
    field :description, :string
		field :instruction, :string
		field :type, :string
		field :priority, :string
		field :deadline, Ecto.DateTime

    belongs_to :user, Flexphoenix.User
		belongs_to :project, Flexphoenix.Project
		belongs_to :asset, Flexphoenix.Asset

    has_many :assigned_technicians, Flexphoenix.AssignedTechnician, on_delete: :delete_all
		has_many :technicians, through: [:assigned_technicians, :user]
    has_many :orders, Flexphoenix.Order, on_delete: :delete_all

    timestamps
  end

  @required_fields ~w(title location description)
  @optional_fields ~w(project_id asset_id instruction worktype type priority deadline)

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
