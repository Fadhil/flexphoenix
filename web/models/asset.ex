defmodule Flexphoenix.Asset do
  use Flexphoenix.Web, :model

  schema "assets" do
    field :name, :string
    field :model_id, :string
    field :manufacturer, :string
    field :photo, :string
    belongs_to :project, Flexphoenix.Project
    has_many :requests, Flexphoenix.Request

    timestamps
  end

  @required_fields ~w(name model_id manufacturer photo)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def create_changeset(model, project_id, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> put_project_id(project_id)
  end

  def put_project_id(changeset, project_id) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        put_change(changeset, :project_id, project_id)
      _ ->
        changeset
    end
  end

  def with_project(query) do
    from q in query, preload: [:project]
  end
end
