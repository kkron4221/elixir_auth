defmodule BrightWeb.OauthController do
  use BrightWeb, :controller
  plug Ueberauth

  alias Ueberauth.Strategy.Helpers

  def request(conn, _params), do: nil

  def callback(%{assigns: %{ueberauth_auth: %Ueberauth.Auth{} = auth}} = conn, _params) do
    conn
    |> put_flash(:info, "Succeed to authenticate!")
    |> put_session(:current_user, auth.uid)
    |> configure_session(renew: true)
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: %Ueberauth.Failure{} = _failure}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end
end

