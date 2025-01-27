defmodule Flexcility.ReportControllerTest do
  use Flexcility.ConnCase

  alias Flexcility.Report
  @valid_attrs %{actions: "some content", completed: "some content", deadline: "some content", description: "some content", findings: "some content", instruction: "some content", location: "some content", priority: "some content", summary: "some content", title: "some content", type: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, report_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing reports"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, report_path(conn, :new)
    assert html_response(conn, 200) =~ "New report"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, report_path(conn, :create), report: @valid_attrs
    assert redirected_to(conn) == report_path(conn, :index)
    assert Repo.get_by(Report, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, report_path(conn, :create), report: @invalid_attrs
    assert html_response(conn, 200) =~ "New report"
  end

  test "shows chosen resource", %{conn: conn} do
    report = Repo.insert! %Report{}
    conn = get conn, report_path(conn, :show, report)
    assert html_response(conn, 200) =~ "Show report"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, report_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    report = Repo.insert! %Report{}
    conn = get conn, report_path(conn, :edit, report)
    assert html_response(conn, 200) =~ "Edit report"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    report = Repo.insert! %Report{}
    conn = put conn, report_path(conn, :update, report), report: @valid_attrs
    assert redirected_to(conn) == report_path(conn, :show, report)
    assert Repo.get_by(Report, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    report = Repo.insert! %Report{}
    conn = put conn, report_path(conn, :update, report), report: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit report"
  end

  test "deletes chosen resource", %{conn: conn} do
    report = Repo.insert! %Report{}
    conn = delete conn, report_path(conn, :delete, report)
    assert redirected_to(conn) == report_path(conn, :index)
    refute Repo.get(Report, report.id)
  end
end
