defmodule :release_tasks do
  def migrate do
    {:ok, _} = Application.ensure_all_started(:flexcility)

    path = Application.app_dir(:flexcility, "/priv/repo/migrations")

    Ecto.Migrator.run(Flexcility.Repo, path, :up, all: true)

    :init.stop()
  end
end
