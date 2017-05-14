# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :discuss,
  ecto_repos: [Discuss.Repo]

# Configures the endpoint
config :discuss, Discuss.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "dvR00hgbRiMz3pl3hmknQVZTzeTH3W72IFCOJcBSd5t36KWjguo+J0V8E4z0iX76",
  render_errors: [view: Discuss.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Discuss.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# config :ueberauth, :ueberauth_github,
#  providers: [
#    github: { Ueberauth.Strategy.Github, []}
#  ]
 config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, [default_scope: "user,public_repo,notifications"]}
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: "07fed6e4e5ea6e87d72b",
  client_secret: "edd64a1e1acb05bbb5eb02628db31a4f7fa0512e"
