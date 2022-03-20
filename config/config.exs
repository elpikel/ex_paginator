use Mix.Config

config :ex_paginator, ExPaginator.Repo,
  database: "ex_paginator",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :ex_paginator, ecto_repos: [ExPaginator.Repo]
