import Config

config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, [default_scope: "email profile https://www.googleapis.com/auth/youtube.force-ssl"]},
    twitch: {Ueberauth.Strategy.Twitch, [default_scope: "user:read:email chat:read chat:edit channel:manage:broadcast analytics:read:games"]},
    twitter: {Ueberauth.Strategy.Twitter, []}
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET")

config :ueberauth, Ueberauth.Strategy.Twitch.OAuth,
  client_id: System.get_env("TWITCH_CLIENT_ID"),
  client_secret: System.get_env("TWITCH_CLIENT_SECRET")

config :ueberauth, Ueberauth.Strategy.Twitter.OAuth,
  consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
  consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET")
