defmodule Flexcility.Organisation do
  use Flexcility.Web, :model

  schema "organisations" do
    field :name, :string
    field :display_name, :string
    field :logo, Flexcility.Image.Type
    field :description, :string

    timestamps()

    belongs_to :user, Flexcility.Organisation
  end

  @all_fields [:name, :display_name, :description]
  @image_fields [:logo]
  @required_fields [:name, :display_name]
  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @all_fields)
    |> cast_attachments(params, @image_fields)
    |> validate_required(@required_fields)
  end

  def create_changeset(struct, user_id, params \\ %{}) do
    struct
    |> cast(params, @required_fields)
    |> cast_attachments(params, @image_fields)
    |> validate_required(@required_fields)
    |> put_user_id(user_id)
  end
end
