defmodule Bright.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bright.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password()
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Bright.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end

  @doc """
  Generate a user_social_auth.
  """
  def user_social_auth_fixture(attrs \\ %{}) do
    {:ok, user_social_auth} =
      attrs
      |> Enum.into(%{
        display_name: "some display_name",
        identifier: "some identifier",
        provider: "some provider",
        token: "some token"
      })
      |> Bright.Accounts.create_user_social_auth()

    user_social_auth
  end
end
