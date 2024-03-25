defmodule BrightWeb.UserSocialAuthLive.FormComponent do
  use BrightWeb, :live_component

  alias Bright.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage user_social_auth records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="user_social_auth-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:provider]} type="text" label="Provider" />
        <.input field={@form[:identifier]} type="text" label="Identifier" />
        <.input field={@form[:token]} type="text" label="Token" />
        <.input field={@form[:display_name]} type="text" label="Display name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save User social auth</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{user_social_auth: user_social_auth} = assigns, socket) do
    changeset = Accounts.change_user_social_auth(user_social_auth)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"user_social_auth" => user_social_auth_params}, socket) do
    changeset =
      socket.assigns.user_social_auth
      |> Accounts.change_user_social_auth(user_social_auth_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"user_social_auth" => user_social_auth_params}, socket) do
    save_user_social_auth(socket, socket.assigns.action, user_social_auth_params)
  end

  defp save_user_social_auth(socket, :edit, user_social_auth_params) do
    case Accounts.update_user_social_auth(socket.assigns.user_social_auth, user_social_auth_params) do
      {:ok, user_social_auth} ->
        notify_parent({:saved, user_social_auth})

        {:noreply,
         socket
         |> put_flash(:info, "User social auth updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_user_social_auth(socket, :new, user_social_auth_params) do
    case Accounts.create_user_social_auth(user_social_auth_params) do
      {:ok, user_social_auth} ->
        notify_parent({:saved, user_social_auth})

        {:noreply,
         socket
         |> put_flash(:info, "User social auth created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
