defmodule Flexcility.PageController do
  use Flexcility.Web, :controller

  def index(conn, _params) do
    conn
    |> put_layout("none.html")
    |> render("index.html")
  end

  def skin_config(conn, _params) do
    render conn, "skin-config.html"
  end
end
