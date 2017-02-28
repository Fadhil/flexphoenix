defmodule Flexcility.PageController do
  use Flexcility.Web, :controller

  def index(conn, _params) do
    conn
    |> put_layout("none.html")
    |> render("index.html")
  end

  def subdomain_not_found(conn, _params) do
    conn
    |> put_layout("none.html")
    |> render(Flexcility.ErrorView, "not_found.html", %{error_message: "The subdomain you specified does not exist"})
  end

  def error(conn, %{error_message: error_message}) do
    conn
    |> put_layout("none.html")
    |> render(Flexcility.ErrorView, "error.html", %{error_message: error_message})
  end
end
