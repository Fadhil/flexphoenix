defmodule Flexcility.Repo.Migrations.DropUniqueConstraintOnInvitations do
  use Ecto.Migration

  def change do
    drop index(:invitations, [
            :organisation_id, :inviter_id, :role_id, :invitee_email

    ], unique: true, name: :unique_invite)
  end
end
