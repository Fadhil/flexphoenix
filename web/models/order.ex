defmodule Flexcility.Order do
  use Flexcility.Web, :model

  schema "orders" do
    field :title, :string
    field :description, :string
    field :location, :string
    field :type, :string
    field :instruction, :string
    field :priority, :string
    field :deadline, Ecto.DateTime

    belongs_to :user, Flexcility.User
    belongs_to :request, Flexcility.Request

    has_many :assigned_technicians, Flexcility.AssignedTechnician
    has_many :technicians, through: [:assigned_technicians, :user]
    has_many :reports, Flexcility.Report
    timestamps
  end

  @required_fields ~w(title description location instruction priority request_id)
  @optional_fields ~w(type deadline)

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
