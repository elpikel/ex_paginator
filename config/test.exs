use Mix.Config

config :ex_paginator, ExPaginator.Repo,
  database: "ex_paginator_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
