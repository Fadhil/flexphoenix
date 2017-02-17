defmodule Flexcility.Repo.Migrations.CreateInvitation do
  use Ecto.Migration

  def change do
    create table(:invitations) do
      add :role_id, :integer
      add :accepted, :boolean, default: false, null: false
      add :viewed, :boolean, default: false, null: false
      add :organisation_id, references(:organisations, on_delete: :delete_all)
      add :inviter_id, references(:users, on_delete: :delete_all)

      timestamps()
    end
    create index(:invitations, [:organisation_id])
    create index(:invitations, [:inviter_id])

  end
end
