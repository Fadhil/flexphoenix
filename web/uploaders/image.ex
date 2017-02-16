defmodule Flexcility.Image do
  use Flexcility.Web, :uploader
  @versions [:original, :thumb, :logo]

  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
  end

  def transform(:thumb, _) do
    {:convert, "-define -strip -thumbnail 250x250^ -gravity center -extent 250x250 -format png", :png}
  end

  def transform(:logo, _) do
    {:convert, "-define -strip -thumbnail 250x250 -gravity center -extent 250x250 -format png", :png}
  end


  # Provide a default URL if there hasn't been a file uploaded
  def default_url(version, scope) do
    "/images/default-image.png"
  end
end
