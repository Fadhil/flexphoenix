defmodule Flexcility.Endpoint do
  use Phoenix.Endpoint, otp_app: :flexcility

  socket "/socket", Flexcility.UserSocket

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/", from: :flexcility, gzip: false,
    only: ~w(css fonts images img js favicon.ico robots.txt)

  plug Plug.Static,
    at: "/uploads", from: "uploads/", gzip: false

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  # domain = case Mix.env do
  #   :prod ->
  #     ".cmms.flexcility.com"
  #   :dev ->
  #     ".flexcility.dev"
  # end

  plug Plug.Session,
    store: :cookie,
    key: "_Flexcility_key",
    signing_salt: "ZjRCjSN5"

  plug Flexcility.Plug.Subdomain, Flexcility.SubdomainRouter
  plug Flexcility.Router
end
