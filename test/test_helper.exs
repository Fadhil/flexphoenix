ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Flexphoenix.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Flexphoenix.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Flexphoenix.Repo)

