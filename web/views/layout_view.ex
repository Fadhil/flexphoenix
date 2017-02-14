defmodule Flexcility.LayoutView do
  use Flexcility.Web, :view
  import Flexcility.Utils.PageTitle
  alias Flexcility.Image
  use Timex
  require Logger
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
  end

  def image(%{image: image} = thing) do
    Flexcility.Image.url({thing.image, thing})
  end

  def image(%{logo: image} = thing) do
    Flexcility.Image.url({thing.logo, thing})
  end

  def image(params) do
    Logger.info("Done doing images " <> (inspect params))
  end

  def profile_image(_) do
    "/images/default_profile_picture.png"
  end


end
