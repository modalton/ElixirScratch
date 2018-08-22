defmodule Scratch.SessionController do
  use Scratch.Web, :controller

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"username" => user, "password" => pass}}) do
      case Scratch.Auth.login_by_username_and_pass(conn,user,pass,repo: Repo) do
        {:ok,conn} ->
          conn
          |> put_flash(:info, "Welcome back!")
          |> redirect(to: page_path(conn, :index))
        {:error, _reason, conn} ->
          conn
          |> put_flash(:error, "Invalid username/password combination")
          |> render("new.html")
      end
  end

  def delete(conn, _) do
    conn
    |> Scratch.Auth.logout()
    |> redirect(to: page_path(conn, :index))
  end
   
end
