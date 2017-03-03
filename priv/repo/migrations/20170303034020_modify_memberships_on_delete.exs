defmodule Flexcility.Repo.Migrations.ModifyMembershipsOnDelete do
  use Ecto.Migration

  def change do
    # Drop existing do_nothing indices
    drop_if_exists index(:memberships, [:user_id])
    drop_if_exists index(:memberships, [:organisation_id])
    drop_if_exists index(:memberships, [:role_id])

    drop constraint(:memberships, "memberships_user_id_fkey" )
    drop constraint(:memberships, "memberships_organisation_id_fkey" )
    drop constraint(:memberships, "memberships_role_id_fkey" )

    # Modify to delete_all on deletion of parent
    alter table(:memberships) do
      modify :user_id, references(:users, on_delete: :delete_all)
      modify :organisation_id, references(:organisations, on_delete: :delete_all)
      modify :role_id, references(:roles, on_delete: :delete_all)
    end

    # Recreate indices
    create index(:memberships, [:user_id])
    create index(:memberships, [:organisation_id])
    create index(:memberships, [:role_id])
  end
end
