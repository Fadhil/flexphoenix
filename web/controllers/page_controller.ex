defmodule Flexphoenix.PageController do
  use Flexphoenix.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
