defmodule Flexphoenix.Project do
  use Flexphoenix.Web, :model

  schema "projects" do
    field :name, :string
    field :description, :string
    field :address, :string
    field :image, Flexphoenix.Image.Type

    belongs_to :user, Flexphoenix.User
    has_many :assets, Flexphoenix.Asset, on_delete: :nilify_all
    has_many :users_roles, Flexphoenix.UsersRole, on_delete: :delete_all
    has_many :members, through: [:users_roles, :user]
    has_many :requests, Flexphoenix.Request, on_delete: :fetch_and_delete

    timestamps
  end

  @required_fields ~w(name description address)
  @optional_fields ~w()

  @required_file_fields ~w()
  @optional_file_fields ~w(image)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> cast_attachments(params, @required_file_fields, @optional_file_fields)
  end

  def create_changeset(model, user_id, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> cast_attachments(params, @required_file_fields, @optional_file_fields)
    |> put_user_id(user_id)
  end

  def put_user_id(changeset, user_id) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        put_change(changeset, :user_id, user_id)
      _ ->
        changeset
    end
  end

  def with_owner(query) do
    from q in query, preload: [:user]
  end

  def owner(project) do
    project.user
  end
end
