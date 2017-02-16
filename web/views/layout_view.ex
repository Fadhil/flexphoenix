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


  def display_nickname(user) do
    case user.profile do
      nil ->
        nil
      profile ->
        full_name = display_name(user)
        case profile.full_name do
          nil ->
            nil
          ^full_name ->
            profile.full_name
          nickname ->
            nickname
        end
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

  def thumb(%{image: image} = thing) do
    Flexcility.Image.url({thing.image, thing}, :thumb)
  end

  def thumb(%{logo: image} = thing) do
    Flexcility.Image.url({thing.logo, thing}, :logo)
  end

  def image(params) do
    "/images/default-image.png"
  end

  def thumb(params) do
    "/images/default_profile_picture.png"
  end

  def profile_image(_) do
    "/images/default_profile_picture.png"
  end


end
