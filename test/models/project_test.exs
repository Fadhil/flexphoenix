defmodule Flexcility.SiteTest do
  use Flexcility.ModelCase

  alias Flexcility.Site

  @valid_attrs %{address: "some content", description: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Site.changeset(%Site{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Site.changeset(%Site{}, @invalid_attrs)
    refute changeset.valid?
  end
end
