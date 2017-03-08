defmodule Flexcility.Repo.Migrations.AddKeyToInvitations do
  use Ecto.Migration

  def change do
    alter table(:invitations) do
      add :key, :string
    end
  end
end
