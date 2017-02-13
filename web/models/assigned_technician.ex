defmodule Flexcility.AssignedTechnician do
  use Flexcility.Web, :model

  schema "assigned_technicians" do
    timestamps

    belongs_to :user, Flexcility.User
    belongs_to :request, Flexcility.Request
    belongs_to :order, Flexcility.Order
    belongs_to :report, Flexcility.Report
  end

  @required_fields ~w(user_id)
  @optional_fields ~w(request_id order_id report_id)

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
