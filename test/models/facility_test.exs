defmodule Flexcility.FacilityTest do
  use Flexcility.ModelCase

  alias Flexcility.Facility

  @valid_attrs %{icon_name: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Facility.changeset(%Facility{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Facility.changeset(%Facility{}, @invalid_attrs)
    refute changeset.valid?
  end
end
