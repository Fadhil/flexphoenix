defmodule Flexphoenix.LayoutView do
  use Flexphoenix.Web, :view

  def display_name(user) do
    case user do
      %{first_name: first_name, last_name: last_name}
        when first_name != "" or last_name != "" ->
          String.trim("#{first_name} #{last_name}")
      %{email: email} ->
        email
      _ -> "Flex User"
    end
  end
end
