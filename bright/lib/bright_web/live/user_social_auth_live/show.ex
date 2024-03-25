defmodule BrightWeb.UserSocialAuthLive.Show do
  use BrightWeb, :live_view

  alias Bright.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:user_social_auth, Accounts.get_user_social_auth!(id))}
  end

  defp page_title(:show), do: "Show User social auth"
  defp page_title(:edit), do: "Edit User social auth"
end
