import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :prokeep, ProkeepWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "Ni32+F5Cn/8H36RZdVSKYEY5y9NEZuk/Zam+cHewjPzX829p6ZZ2P1MC3nZ7RVz8",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :prokeep, rate_limit: 10
