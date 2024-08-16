defmodule Algora.Accounts.Identity do
  use Ecto.Schema
  import Ecto.Changeset

  alias Algora.Accounts.{Identity, User}

  @providers [:github, :google, :twitch, :twitter]

  @derive {Inspect, except: [:provider_token, :provider_refresh_token, :provider_meta]}
  schema "identities" do
    field :provider, :string
    field :provider_token, :string
    field :provider_refresh_token, :string
    field :provider_email, :string
    field :provider_login, :string
    field :provider_name, :string
    field :provider_id, :string
    field :provider_meta, :map
    field :token_expiry, :integer

    belongs_to :user, User

    timestamps()
  end

  @doc """
  A changeset for OAuth registration or update.
  """
  def oauth_changeset(identity, attrs, provider) when provider in @providers do
    identity
    |> cast(attrs, [
      :provider_token,
      :provider_refresh_token,
      :provider_email,
      :provider_login,
      :provider_name,
      :provider_id,
      :token_expiry,
      :user_id
    ])
    |> put_change(:provider, to_string(provider))
    |> put_change(:provider_meta, Map.get(attrs, :provider_meta, %{}))
    |> validate_required([
      :provider,
      :provider_token,
      :provider_email,
      :provider_name,
      :provider_id,
      :user_id
    ])
    |> validate_length(:provider_meta, max: 10_000)
    |> unique_constraint([:provider, :provider_id])
    |> unique_constraint([:user_id, :provider])
  end

  @doc """
  A user changeset for OAuth registration.
  """
  def oauth_registration_changeset(info, primary_email, emails, token, provider) do
    params = %{
      "provider_token" => token,
      "provider_id" => to_string(info["id"]),
      "provider_login" => info["login"],
      "provider_name" => info["name"] || info["login"],
      "provider_email" => primary_email
    }

    %Identity{provider: to_string(provider), provider_meta: %{"user" => info, "emails" => emails}}
    |> cast(params, [
      :provider_token,
      :provider_email,
      :provider_login,
      :provider_name,
      :provider_id
    ])
    |> validate_required([:provider_token, :provider_email, :provider_name, :provider_id])
    |> validate_length(:provider_meta, max: 10_000)
  end

  @doc """
  A user changeset for restream oauth.
  """
  def restream_oauth_changeset(info, user_id, %{token: token, refresh_token: refresh_token}) do
    params = %{
      "provider_token" => token,
      "provider_refresh_token" => refresh_token,
      "provider_id" => to_string(info["id"]),
      "provider_login" => info["username"],
      "provider_name" => info["username"],
      "provider_email" => info["email"],
      "user_id" => user_id
    }

    %Identity{provider: @restream, provider_meta: %{"user" => info}}
    |> cast(params, [
      :provider_token,
      :provider_refresh_token,
      :provider_email,
      :provider_login,
      :provider_name,
      :provider_id,
      :user_id
    ])
    |> validate_required([
      :provider_token,
      :provider_refresh_token,
      :provider_email,
      :provider_name,
      :provider_id,
      :user_id
    ])
    |> validate_length(:provider_meta, max: 10_000)
  end
end
