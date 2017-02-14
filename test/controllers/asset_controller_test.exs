defmodule Flexcility.AssetControllerTest do
  use Flexcility.ConnCase

  alias Flexcility.Asset
  @valid_attrs %{manufacturer: "some content", model_id: "some content", name: "some content", photo: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, asset_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing assets"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, asset_path(conn, :new)
    assert html_response(conn, 200) =~ "New asset"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, asset_path(conn, :create), asset: @valid_attrs
    assert redirected_to(conn) == asset_path(conn, :index)
    assert Repo.get_by(Asset, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, asset_path(conn, :create), asset: @invalid_attrs
    assert html_response(conn, 200) =~ "New asset"
  end

  test "shows chosen resource", %{conn: conn} do
    asset = Repo.insert! %Asset{}
    conn = get conn, asset_path(conn, :show, asset)
    assert html_response(conn, 200) =~ "Show asset"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, asset_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    asset = Repo.insert! %Asset{}
    conn = get conn, asset_path(conn, :edit, asset)
    assert html_response(conn, 200) =~ "Edit asset"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    asset = Repo.insert! %Asset{}
    conn = put conn, asset_path(conn, :update, asset), asset: @valid_attrs
    assert redirected_to(conn) == asset_path(conn, :show, asset)
    assert Repo.get_by(Asset, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    asset = Repo.insert! %Asset{}
    conn = put conn, asset_path(conn, :update, asset), asset: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit asset"
  end

  test "deletes chosen resource", %{conn: conn} do
    asset = Repo.insert! %Asset{}
    conn = delete conn, asset_path(conn, :delete, asset)
    assert redirected_to(conn) == asset_path(conn, :index)
    refute Repo.get(Asset, asset.id)
  end
end
