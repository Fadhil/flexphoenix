defmodule Flexphoenix.OrganisationTest do
  use Flexphoenix.ModelCase

  alias Flexphoenix.Organisation

  @valid_attrs %{description: "some content", display_name: "some content", logo: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Organisation.changeset(%Organisation{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Organisation.changeset(%Organisation{}, @invalid_attrs)
    refute changeset.valid?
  end
end
