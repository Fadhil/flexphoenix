defmodule Flexcility.Repo.Migrations.ReaddOriginalInvitationUniqueIndex do
  use Ecto.Migration

  def change do
    create index(:invitations, [
                  :organisation_id, :inviter_id, :role_id, :invitee_email
    ], unique: true, name: :unique_invite)
  end
end
