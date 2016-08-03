defmodule Flexphoenix.AssignedTechnician do
  use Flexphoenix.Web, :model

  schema "assigned_technicians" do
    field :user_id, :integer
    field :request_id, :integer
    field :order_id, :integer

    timestamps

    has_many :users, Flexphoenix.User
    has_many :requests, Flexphoenix.Request
    has_many :orders, Flexphoenix.Order
  end

  @required_fields ~w(user_id)
  @optional_fields ~w(request_id order_id)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

end
