defmodule Flexcility.TraitTest do
  use Flexcility.ModelCase

  alias Flexcility.Trait

  @valid_attrs %{abbreviation: "some content", code: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Trait.changeset(%Trait{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Trait.changeset(%Trait{}, @invalid_attrs)
    refute changeset.valid?
  end
end
