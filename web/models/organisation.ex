defmodule Flexcility.Organisation do
  use Flexcility.Web, :model

  schema "organisations" do
    field :name, :string
    field :display_name, :string
    field :logo, Flexcility.Image.Type
    field :description, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :display_name, :description])
    |> cast_attachments(params, [:logo])
    |> validate_required([:name, :display_name])
  end
end
