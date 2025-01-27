defmodule Flexcility.ProfileTest do
  use Flexcility.ModelCase

  alias Flexcility.Profile

  @valid_attrs %{full_name: "some content", image: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Profile.changeset(%Profile{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Profile.changeset(%Profile{}, @invalid_attrs)
    refute changeset.valid?
  end
end
