defmodule Flexcility.Asset do
  use Flexcility.Web, :model

  schema "assets" do
    field :name, :string
    field :model_id, :string
    field :manufacturer, :string
    field :photo, Flexcility.Image.Type
    belongs_to :site, Flexcility.Site
    has_many :requests, Flexcility.Request, on_delete: :delete_all

    timestamps
  end

  @required_fields ~w(name model_id manufacturer )
  @optional_fields ~w()

  @required_file_fields ~w()
  @optional_file_fields ~w(photo)
  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields)
    |> cast_attachments(params, @optional_file_fields)
  end

  def create_changeset(model, site_id, params \\ %{}) do
    model
    |> cast(params, @required_fields)
    |> cast_attachments(params, @optional_file_fields)
    |> put_site_id(site_id)
  end

  def put_site_id(changeset, site_id) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        put_change(changeset, :site_id, site_id)
      _ ->
        changeset
    end
  end

  def with_project(query) do
    from q in query, preload: [:site]
  end
end
