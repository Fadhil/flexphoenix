defmodule Flexcility.Repo.Migrations.AddNewUniqueConstraintOnInvitations do
  use Ecto.Migration

  def change do
    create index(:invitations, [
            :organisation_subdomain, :inviter_id, :role_id, :invitee_email

    ], unique: true, name: :unique_invite)
  end
end
