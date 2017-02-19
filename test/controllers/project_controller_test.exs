defmodule Flexcility.SiteControllerTest do
  use Flexcility.ConnCase

  alias Flexcility.Site
  @valid_attrs %{address: "some content", description: "some content", name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, site_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing sites"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, site_path(conn, :new)
    assert html_response(conn, 200) =~ "New project"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, site_path(conn, :create), site: @valid_attrs
    assert redirected_to(conn) == site_path(conn, :index)
    assert Repo.get_by(Site, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, site_path(conn, :create), site: @invalid_attrs
    assert html_response(conn, 200) =~ "New project"
  end

  test "shows chosen resource", %{conn: conn} do
    project = Repo.insert! %Site{}
    conn = get conn, site_path(conn, :show, project)
    assert html_response(conn, 200) =~ "Show project"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, site_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    project = Repo.insert! %Site{}
    conn = get conn, site_path(conn, :edit, project)
    assert html_response(conn, 200) =~ "Edit project"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    project = Repo.insert! %Site{}
    conn = put conn, site_path(conn, :update, project), site: @valid_attrs
    assert redirected_to(conn) == site_path(conn, :show, project)
    assert Repo.get_by(Site, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    project = Repo.insert! %Site{}
    conn = put conn, site_path(conn, :update, project), site: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit project"
  end

  test "deletes chosen resource", %{conn: conn} do
    project = Repo.insert! %Site{}
    conn = delete conn, site_path(conn, :delete, project)
    assert redirected_to(conn) == site_path(conn, :index)
    refute Repo.get(Site, project.id)
  end
end
