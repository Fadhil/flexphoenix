defmodule Flexphoenix.PasswordController do
  use Flexphoenix.Web, :controller

  def forget_password(conn, _) do
    conn
    |> put_layout("none.html")
    |> render(:forget_password)
  end

  def reset_password(conn, %{"user" => %{"email" => _email}}) do
    conn
    |> put_flash(:info, "Password reset link has been sent to your email address.")
    |> redirect(to: session_path(conn, :new))
  end
end
