defmodule Flexcility.Utils.Form do
  @doc """
  Filter checkbox params by value (true/false)

  Returns a list of filtered keys, i.e. `["1", "2"]`

  ## Examples

      iex> checkbox_params = %{"1" => "true", "2" => "false", "3" => "true"}
      iex> Flexcility.Utils.Form.filter_checkbox_params(checkbox_params, true)
      ["1", "3"]

      iex> checkbox_params = %{"1" => "false", "2" => "false", "3" => "true"}
      iex> Flexcility.Utils.Form.filter_checkbox_params(checkbox_params, "false")
      ["1", "2"]

      iex> checkbox_params = %{"1" => "false", "2" => "false", "3" => "false"}
      iex> Flexcility.Utils.Form.filter_checkbox_params(checkbox_params, "true")
      []
  """
  def filter_checkbox_params(params, filter_value) when is_boolean(filter_value) do
    filter_checkbox_params(params, to_string(filter_value))
  end

  def filter_checkbox_params(params, filter_value) do
    params
    |> Enum.filter(fn({_k,v}) -> v == filter_value end)
    |> Enum.map(fn({k,_v}) -> k end )
  end

  @doc """
  Takes a list of "string" ids and returns a list of integers. Filters out
  nil values.

  Returns `[1, 2, 3]`

  ## Examples
      iex> string_ids = ["1", "2", "3"]
      iex> Flexcility.Utils.Form.ids_from_strings(string_ids)
      [1, 2, 3]

      iex> string_ids = ["1", "", "3"]
      iex> Flexcility.Utils.Form.ids_from_strings(string_ids)
      [1, 3]

      iex> string_ids = [""]
      iex> Flexcility.Utils.Form.ids_from_strings(string_ids)
      []
  """
  def ids_from_strings(string_ids) do
    string_ids |> Enum.map(fn(x) ->
      case Integer.parse(x) do
        :error -> nil
        {integer, _} -> integer
      end
    end) |> Enum.filter(fn(z) -> z != nil end )
  end
end
