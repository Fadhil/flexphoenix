defmodule Flexcility.Utils.PageTitle do
  import Inflex
  def page_title(path_info, action_name, the_things_name \\ %{}) do
    {path_info, action_name, the_things_name} |> get #|> add_dash
  end

  def add_dash(nil), do: nil
  def add_dash(title), do: " - " <> title

  def get({[the_thing|tail], action_name, %{page_title: page_title}}) do
    case action_name do
      :new ->
        String.capitalize(to_string(action_name)) <> " " <> String.capitalize(singularize(the_thing))
      :edit ->
        String.capitalize(to_string(action_name)) <> " " <> String.capitalize(singularize(the_thing)) <> " - " <> page_title
      _ ->
        String.capitalize(singularize(the_thing)) <> " - " <> page_title
    end
  end

  def get({["requests"|tail], action_name, the_things_name}) do
    get({["work requests"],action_name, the_things_name})
  end
  def get({["orders"|tail],action_name, the_things_name}) do
    get({["work orders"],action_name, the_things_name})
  end
  def get({[the_thing|tail],action_name, %{}}) do
    case action_name do
      :index ->
        String.capitalize(the_thing)
      _ ->
        String.capitalize(singularize(the_thing))
    end
  end
end
