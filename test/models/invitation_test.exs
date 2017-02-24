defmodule Flexcility.InvitationTest do
  use Flexcility.ModelCase

  alias Flexcility.Invitation

  @valid_attrs %{accepted: true, role_id: 42, viewed: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Invitation.changeset(%Invitation{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Invitation.changeset(%Invitation{}, @invalid_attrs)
    refute changeset.valid?
  end
end
