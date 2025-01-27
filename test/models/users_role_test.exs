defmodule Flexcility.UsersRoleTest do
  use Flexcility.ModelCase

  alias Flexcility.UsersRole

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = UsersRole.changeset(%UsersRole{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UsersRole.changeset(%UsersRole{}, @invalid_attrs)
    refute changeset.valid?
  end
end
