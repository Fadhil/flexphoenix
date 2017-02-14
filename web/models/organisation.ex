defmodule Flexcility.Organisation do
  use Flexcility.Web, :model

  schema "organisations" do
    field :name, :string
    field :display_name, :string
    field :logo, Flexcility.Image.Type
    field :description, :string

    timestamps()

    has_many :memberships, Flexcility.Membership, on_delete: :delete_all
    has_many :users, through: [:memberships, :user]
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
end
