defmodule Bright.Accounts.UserSocialAuth do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_social_auths" do
    field :display_name, :string
    field :identifier, :string
    field :provider, :string
    field :token, :binary
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user_social_auth, attrs) do
    user_social_auth
    |> cast(attrs, [:provider, :identifier, :token, :display_name])
    |> validate_required([:provider, :identifier, :token, :display_name])
  end
end
