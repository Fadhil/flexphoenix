defmodule Flexcility.OrganisationManagementControllerTest do
  use Flexcility.ConnCase

  alias Flexcility.OrganisationManagement
  @valid_attrs %{}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, organisation_management_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing organisation managements"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, organisation_management_path(conn, :new)
    assert html_response(conn, 200) =~ "New organisation management"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, organisation_management_path(conn, :create), organisation_management: @valid_attrs
    assert redirected_to(conn) == organisation_management_path(conn, :index)
    assert Repo.get_by(OrganisationManagement, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, organisation_management_path(conn, :create), organisation_management: @invalid_attrs
    assert html_response(conn, 200) =~ "New organisation management"
  end

  test "shows chosen resource", %{conn: conn} do
    organisation_management = Repo.insert! %OrganisationManagement{}
    conn = get conn, organisation_management_path(conn, :show, organisation_management)
    assert html_response(conn, 200) =~ "Show organisation management"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, organisation_management_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    organisation_management = Repo.insert! %OrganisationManagement{}
    conn = get conn, organisation_management_path(conn, :edit, organisation_management)
    assert html_response(conn, 200) =~ "Edit organisation management"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    organisation_management = Repo.insert! %OrganisationManagement{}
    conn = put conn, organisation_management_path(conn, :update, organisation_management), organisation_management: @valid_attrs
    assert redirected_to(conn) == organisation_management_path(conn, :show, organisation_management)
    assert Repo.get_by(OrganisationManagement, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    organisation_management = Repo.insert! %OrganisationManagement{}
    conn = put conn, organisation_management_path(conn, :update, organisation_management), organisation_management: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit organisation management"
  end

  test "deletes chosen resource", %{conn: conn} do
    organisation_management = Repo.insert! %OrganisationManagement{}
    conn = delete conn, organisation_management_path(conn, :delete, organisation_management)
    assert redirected_to(conn) == organisation_management_path(conn, :index)
    refute Repo.get(OrganisationManagement, organisation_management.id)
  end
end
