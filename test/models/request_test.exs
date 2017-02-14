defmodule Flexcility.RequestTest do
  use Flexcility.ModelCase

  alias Flexcility.Request

  @valid_attrs %{description: "some content", location: "some content", title: "some content", worktype: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Request.changeset(%Request{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Request.changeset(%Request{}, @invalid_attrs)
    refute changeset.valid?
  end
end
