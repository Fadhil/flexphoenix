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
end
