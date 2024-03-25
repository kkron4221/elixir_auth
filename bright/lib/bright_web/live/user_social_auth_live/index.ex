defmodule BrightWeb.UserSocialAuthLive.Index do
  use BrightWeb, :live_view

  alias Bright.Accounts
  alias Bright.Accounts.UserSocialAuth

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :user_social_auths, Accounts.list_user_social_auths())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit User social auth")
    |> assign(:user_social_auth, Accounts.get_user_social_auth!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New User social auth")
    |> assign(:user_social_auth, %UserSocialAuth{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing User social auths")
    |> assign(:user_social_auth, nil)
  end

  @impl true
  def handle_info({BrightWeb.UserSocialAuthLive.FormComponent, {:saved, user_social_auth}}, socket) do
    {:noreply, stream_insert(socket, :user_social_auths, user_social_auth)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user_social_auth = Accounts.get_user_social_auth!(id)
    {:ok, _} = Accounts.delete_user_social_auth(user_social_auth)

    {:noreply, stream_delete(socket, :user_social_auths, user_social_auth)}
  end
end
