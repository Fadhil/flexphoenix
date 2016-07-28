defmodule Flexphoenix.OrderTest do
  use Flexphoenix.ModelCase

  alias Flexphoenix.Order

  @valid_attrs %{body: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Order.changeset(%Order{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Order.changeset(%Order{}, @invalid_attrs)
    refute changeset.valid?
  end
end
