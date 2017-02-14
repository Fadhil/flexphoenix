defmodule Flexcility.ReportTest do
  use Flexcility.ModelCase

  alias Flexcility.Report

  @valid_attrs %{actions: "some content", completed: "some content", deadline: "some content", description: "some content", findings: "some content", instruction: "some content", location: "some content", priority: "some content", summary: "some content", title: "some content", type: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Report.changeset(%Report{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Report.changeset(%Report{}, @invalid_attrs)
    refute changeset.valid?
  end
end
