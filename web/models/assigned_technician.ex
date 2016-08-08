defmodule Flexphoenix.AssignedTechnician do
  use Flexphoenix.Web, :model

  schema "assigned_technicians" do
    timestamps

    belongs_to :user, Flexphoenix.User
    belongs_to :request, Flexphoenix.Request
    belongs_to :order, Flexphoenix.Order
    belongs_to :report, Flexphoenix.Report
  end

  @required_fields ~w(user_id)
  @optional_fields ~w(request_id order_id)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

end
