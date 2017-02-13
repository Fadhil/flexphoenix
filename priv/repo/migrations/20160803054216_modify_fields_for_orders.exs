defmodule Flexcility.Repo.Migrations.ModifyFieldsForOrders do
  use Ecto.Migration

  # To save in postgres datetime format
  # We could have tried to use modify :deadline, :datetime
  # but then postgres wouldn't know how to modify the currently existing
  # data in the deadline column, and ecto.migrate throws an error
  #
  # => ERROR (datatype_mismatch): column "deadline" cannot be cast
  #    automatically to type timestamp without time zone
  #
  # So instead we remove the column and readd it
  def up do
    alter table(:orders) do
      remove :deadline
      add :deadline, :datetime
    end
  end

  # When we do rollback, ecto doesn't know what the original type was
  # so we have to specifically say change it back to string on down/rollback
  def down do
    alter table(:orders) do
      remove :deadline
      add :deadline, :string
    end
  end
end
