defmodule Flexcility.InvitationControllerTest do
  use Flexcility.ConnCase

  alias Flexcility.Invitation
  @valid_attrs %{accepted: true, role_id: 42, viewed: true}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, invitation_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing invitations"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, invitation_path(conn, :new)
    assert html_response(conn, 200) =~ "New invitation"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, invitation_path(conn, :create), invitation: @valid_attrs
    assert redirected_to(conn) == invitation_path(conn, :index)
    assert Repo.get_by(Invitation, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, invitation_path(conn, :create), invitation: @invalid_attrs
    assert html_response(conn, 200) =~ "New invitation"
  end

  test "shows chosen resource", %{conn: conn} do
    invitation = Repo.insert! %Invitation{}
    conn = get conn, invitation_path(conn, :show, invitation)
    assert html_response(conn, 200) =~ "Show invitation"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, invitation_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    invitation = Repo.insert! %Invitation{}
    conn = get conn, invitation_path(conn, :edit, invitation)
    assert html_response(conn, 200) =~ "Edit invitation"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    invitation = Repo.insert! %Invitation{}
    conn = put conn, invitation_path(conn, :update, invitation), invitation: @valid_attrs
    assert redirected_to(conn) == invitation_path(conn, :show, invitation)
    assert Repo.get_by(Invitation, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    invitation = Repo.insert! %Invitation{}
    conn = put conn, invitation_path(conn, :update, invitation), invitation: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit invitation"
  end

  test "deletes chosen resource", %{conn: conn} do
    invitation = Repo.insert! %Invitation{}
    conn = delete conn, invitation_path(conn, :delete, invitation)
    assert redirected_to(conn) == invitation_path(conn, :index)
    refute Repo.get(Invitation, invitation.id)
  end
end
