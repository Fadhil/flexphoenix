defmodule Flexcility.Repo.Migrations.CreateReport do
  use Ecto.Migration

  def change do
    create table(:reports) do
      add :title, :string
      add :description, :text
      add :location, :string
      add :type, :string
      add :instruction, :text
      add :priority, :string
      add :deadline, :string
      add :findings, :text
      add :actions, :text
      add :summary, :text
      add :completed, :string

      timestamps
    end

  end
end
