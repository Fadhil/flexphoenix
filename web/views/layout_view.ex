defmodule Flexphoenix.LayoutView do
  use Flexphoenix.Web, :view
  alias Flexphoenix.Image
  use Timex

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

  def display_created_at(object) do
    case object do
      %{inserted_at: inserted_at} ->
        Timex.format!(object.inserted_at, "%d/%m/%Y", :strftime)

    end
  end

  def image(%{image: nil} ) do
    "/images/default-image.jpg"
  end

  def image(%{photo: nil} ) do
    "/images/default-image.jpg"
  end

  def image(%{photo: image} = thing) do
    Image.url({image, thing})
    |> String.replace("priv/static", "")
    |> String.replace("/apps/flexphoenix", "")
  end

  def image(%{image: image} = thing) do
    Image.url({image, thing})
    |> String.replace("priv/static", "")
    |> String.replace("/apps/flexphoenix", "")
  end

  def profile_image(_) do
    "/images/default_profile_picture.png"
  end
end
