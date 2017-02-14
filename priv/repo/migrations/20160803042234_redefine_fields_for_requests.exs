defmodule Flexcility.Repo.Migrations.RedefineFieldsForRequests do
  use Ecto.Migration

  def up do
    alter table(:requests) do
      add :instruction, :text
      add :type, :string
      add :priority, :string
      add :deadline, :datetime
    end
  end

  def down do
    alter table(:requests) do
      drop :instruction
      drop :type
      drop :priority
      drop :deadline
    end
  end
end
