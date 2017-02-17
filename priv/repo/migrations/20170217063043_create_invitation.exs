defmodule Flexcility.Repo.Migrations.CreateInvitation do
  use Ecto.Migration

  def change do
    create table(:invitations) do
      add :accepted, :boolean, default: false, null: false
      add :viewed, :boolean, default: false, null: false
      add :invitee_email, :string
      add :role_id, references(:roles, on_delete: :nothing)
      add :organisation_id, references(:organisations, on_delete: :delete_all)
      add :inviter_id, references(:users, on_delete: :delete_all)

      timestamps()
    end
    create index(:invitations, [:organisation_id])
    create index(:invitations, [:inviter_id])
    create index(:invitations, [:role_id])
    create index(:invitations, [:invitee_email])
    create index(:invitations, [
      :organisation_id, :inviter_id, :role_id, :invitee_email
    ], unique: true, name: :unique_invite)

  end
end
