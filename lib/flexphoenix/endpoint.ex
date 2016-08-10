defmodule Flexphoenix.Endpoint do
  use Phoenix.Endpoint, otp_app: :flexphoenix

  socket "/socket", Flexphoenix.UserSocket

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/", from: :flexphoenix, gzip: false,
    only: ~w(css fonts images img js favicon.ico robots.txt)

  plug Plug.Static,
    at: "/uploads", from: "/apps/flexphoenix/uploads/", gzip: false

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

  plug Plug.Session,
    store: :cookie,
    key: "_flexphoenix_key",
    signing_salt: "ZjRCjSN5"

  plug Flexphoenix.Router
end
