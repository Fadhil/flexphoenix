defmodule Flexcility.Site do
  use Flexcility.Web, :model

  schema "sites" do
    field :name, :string
    field :description, :string
    field :address, :string
    field :image, Flexcility.Image.Type

    timestamps

    belongs_to :organisation, Flexcility.Organisation
    has_many :installed_assets, Flexcility.InstalledAsset, on_delete: :delete_all
    has_many :assets, through: [:installed_assets, :asset]
    has_many :users_roles, Flexcility.UsersRole, on_delete: :delete_all
    has_many :members, through: [:users_roles, :user]
    has_many :requests, Flexcility.Request, on_delete: :delete_all

    many_to_many :traits, Flexcility.Trait, join_through: "sites_traits"

  end

  @all_fields ~w(name description address)
  @required_fields [:name, :description, :address]
  @optional_fields ~w()
  @image_fields ~w(image)

  @required_file_fields ~w()
  @optional_file_fields [:image]

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

  def create_changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields)
    |> cast_attachments(params, @optional_file_fields)
    |> validate_required(@required_fields)
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

  def image_changeset(site, params) do
    site
    |> cast_attachments(params, @image_fields)
  end
end
