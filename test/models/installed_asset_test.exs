defmodule Flexcility.InstalledAssetTest do
  use Flexcility.ModelCase

  alias Flexcility.InstalledAsset

  @valid_attrs %{installation_date: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, notes: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = InstalledAsset.changeset(%InstalledAsset{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = InstalledAsset.changeset(%InstalledAsset{}, @invalid_attrs)
    refute changeset.valid?
  end
end
