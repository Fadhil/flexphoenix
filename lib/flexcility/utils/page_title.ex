defmodule Flexcility.Utils.PageTitle do
  import Inflex
  require IEx
  def page_title(conn) do
    conn.assigns[:page_title] || ""
  end
end
