defmodule Flexphoenix.AssetTest do
  use Flexphoenix.ModelCase

  alias Flexphoenix.Asset

  @valid_attrs %{manufacturer: "some content", model_id: "some content", name: "some content", photo: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Asset.changeset(%Asset{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Asset.changeset(%Asset{}, @invalid_attrs)
    refute changeset.valid?
  end
end
