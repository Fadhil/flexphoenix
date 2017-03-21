defmodule Flexcility.Organisation.TraitControllerTest do
  use Flexcility.ConnCase
  doctest Flexcility.Organisation.TraitController

  # alias Flexcility.Trait
  # @valid_attrs %{abbreviation: "some content", code: "some content", name: "some content"}
  # @invalid_attrs %{}

  # test "lists all entries on index", %{conn: conn} do
  #   conn = get conn, organisation_trait_path(conn, :index)
  #   assert html_response(conn, 200) =~ "Listing traits"
  # end
  #
  # test "renders form for new resources", %{conn: conn} do
  #   conn = get conn, organisation_trait_path(conn, :new)
  #   assert html_response(conn, 200) =~ "New trait"
  # end
  #
  # test "creates resource and redirects when data is valid", %{conn: conn} do
  #   conn = post conn, organisation_trait_path(conn, :create), trait: @valid_attrs
  #   assert redirected_to(conn) == organisation_trait_path(conn, :index)
  #   assert Repo.get_by(Trait, @valid_attrs)
  # end
  #
  # test "does not create resource and renders errors when data is invalid", %{conn: conn} do
  #   conn = post conn, organisation_trait_path(conn, :create), trait: @invalid_attrs
  #   assert html_response(conn, 200) =~ "New trait"
  # end
  #
  # test "shows chosen resource", %{conn: conn} do
  #   trait = Repo.insert! %Trait{}
  #   conn = get conn, organisation_trait_path(conn, :show, trait)
  #   assert html_response(conn, 200) =~ "Show trait"
  # end
  #
  # test "renders page not found when id is nonexistent", %{conn: conn} do
  #   assert_error_sent 404, fn ->
  #     get conn, organisation_trait_path(conn, :show, -1)
  #   end
  # end
  #
  # test "renders form for editing chosen resource", %{conn: conn} do
  #   trait = Repo.insert! %Trait{}
  #   conn = get conn, organisation_trait_path(conn, :edit, trait)
  #   assert html_response(conn, 200) =~ "Edit trait"
  # end
  #
  # test "updates chosen resource and redirects when data is valid", %{conn: conn} do
  #   trait = Repo.insert! %Trait{}
  #   conn = put conn, organisation_trait_path(conn, :update, trait), trait: @valid_attrs
  #   assert redirected_to(conn) == organisation_trait_path(conn, :show, trait)
  #   assert Repo.get_by(Trait, @valid_attrs)
  # end
  #
  # test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
  #   trait = Repo.insert! %Trait{}
  #   conn = put conn, organisation_trait_path(conn, :update, trait), trait: @invalid_attrs
  #   assert html_response(conn, 200) =~ "Edit trait"
  # end
  #
  # test "deletes chosen resource", %{conn: conn} do
  #   trait = Repo.insert! %Trait{}
  #   conn = delete conn, organisation_trait_path(conn, :delete, trait)
  #   assert redirected_to(conn) == organisation_trait_path(conn, :index)
  #   refute Repo.get(Trait, trait.id)
  # end
end
