defmodule AlgoraWeb.AuthController do
  use AlgoraWeb, :controller
  plug Ueberauth

  alias Algora.Accounts
  alias AlgoraWeb.UserAuth

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_params = %{
      email: auth.info.email,
      name: auth.info.name,
      avatar: auth.info.image
    }

    identity_params = %{
      provider_token: auth.credentials.token,
      provider_refresh_token: auth.credentials.refresh_token,
      provider_email: auth.info.email,
      provider_login: auth.info.nickname,
      provider_name: auth.info.name,
      provider_id: auth.uid,
      token_expiry: auth.credentials.expires_at,
      provider_meta: auth.extra
    }

    case Accounts.get_or_create_user_with_identity(user_params, identity_params, auth.provider) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> UserAuth.log_in_user(user)

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Authentication failed.")
        |> redirect(to: "/")
    end
  end

  def callback(conn, _params) do
    conn
    |> put_flash(:error, "Authentication failed.")
    |> redirect(to: "/")
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
