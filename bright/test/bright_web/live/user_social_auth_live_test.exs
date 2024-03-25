defmodule BrightWeb.UserSocialAuthLiveTest do
  use BrightWeb.ConnCase

  import Phoenix.LiveViewTest
  import Bright.AccountsFixtures

  @create_attrs %{display_name: "some display_name", identifier: "some identifier", provider: "some provider", token: "some token"}
  @update_attrs %{display_name: "some updated display_name", identifier: "some updated identifier", provider: "some updated provider", token: "some updated token"}
  @invalid_attrs %{display_name: nil, identifier: nil, provider: nil, token: nil}

  defp create_user_social_auth(_) do
    user_social_auth = user_social_auth_fixture()
    %{user_social_auth: user_social_auth}
  end

  describe "Index" do
    setup [:create_user_social_auth]

    test "lists all user_social_auths", %{conn: conn, user_social_auth: user_social_auth} do
      {:ok, _index_live, html} = live(conn, ~p"/user_social_auths")

      assert html =~ "Listing User social auths"
      assert html =~ user_social_auth.display_name
    end

    test "saves new user_social_auth", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/user_social_auths")

      assert index_live |> element("a", "New User social auth") |> render_click() =~
               "New User social auth"

      assert_patch(index_live, ~p"/user_social_auths/new")

      assert index_live
             |> form("#user_social_auth-form", user_social_auth: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#user_social_auth-form", user_social_auth: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/user_social_auths")

      html = render(index_live)
      assert html =~ "User social auth created successfully"
      assert html =~ "some display_name"
    end

    test "updates user_social_auth in listing", %{conn: conn, user_social_auth: user_social_auth} do
      {:ok, index_live, _html} = live(conn, ~p"/user_social_auths")

      assert index_live |> element("#user_social_auths-#{user_social_auth.id} a", "Edit") |> render_click() =~
               "Edit User social auth"

      assert_patch(index_live, ~p"/user_social_auths/#{user_social_auth}/edit")

      assert index_live
             |> form("#user_social_auth-form", user_social_auth: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#user_social_auth-form", user_social_auth: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/user_social_auths")

      html = render(index_live)
      assert html =~ "User social auth updated successfully"
      assert html =~ "some updated display_name"
    end

    test "deletes user_social_auth in listing", %{conn: conn, user_social_auth: user_social_auth} do
      {:ok, index_live, _html} = live(conn, ~p"/user_social_auths")

      assert index_live |> element("#user_social_auths-#{user_social_auth.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#user_social_auths-#{user_social_auth.id}")
    end
  end

  describe "Show" do
    setup [:create_user_social_auth]

    test "displays user_social_auth", %{conn: conn, user_social_auth: user_social_auth} do
      {:ok, _show_live, html} = live(conn, ~p"/user_social_auths/#{user_social_auth}")

      assert html =~ "Show User social auth"
      assert html =~ user_social_auth.display_name
    end

    test "updates user_social_auth within modal", %{conn: conn, user_social_auth: user_social_auth} do
      {:ok, show_live, _html} = live(conn, ~p"/user_social_auths/#{user_social_auth}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit User social auth"

      assert_patch(show_live, ~p"/user_social_auths/#{user_social_auth}/show/edit")

      assert show_live
             |> form("#user_social_auth-form", user_social_auth: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#user_social_auth-form", user_social_auth: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/user_social_auths/#{user_social_auth}")

      html = render(show_live)
      assert html =~ "User social auth updated successfully"
      assert html =~ "some updated display_name"
    end
  end
end
