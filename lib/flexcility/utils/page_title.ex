defmodule Flexcility.Utils.PageTitle do
  import Inflex
  def page_title(path_info, action_name) do
    [path_info, action_name] |> get #|> add_dash
  end

  def add_dash(nil), do: nil
  def add_dash(title), do: " - " <> title
  def get([["requests"|tail],action_name]) do
    get([["work requests"],action_name])
  end
  def get([["orders"|tail],action_name]) do
    get([["work orders"],action_name])
  end
  def get([[the_thing|tail],action_name]) do
    case action_name do
      :index ->
        String.capitalize(the_thing)
      _ ->
        String.capitalize(to_string(action_name)) <> " " <> singularize(the_thing)
    end
  end

end
