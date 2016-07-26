defmodule :release_tasks do
  def migrate do
    {:ok, _} = Application.ensure_all_started(:flexphoenix)

    path = Application.app_dir(:flexphoenix, "/priv/repo/migrations")

    Ecto.Migrator.run(Flexphoenix.Repo, path, :up, all: true)

    :init.stop()
  end
end
