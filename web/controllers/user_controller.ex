defmodule Scratch.UserController do
  use Scratch.Web, :controller
  plug :authenticate when action in [:index, :show]
  alias Scratch.User
  
  def index(conn, _params) do
    users = Repo.all(Scratch.User)
    render conn, "index.html", users: users
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(Scratch.User,id)
    render conn, "show.html", user: user
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{},_params)
    render conn, "new.html", changeset: changeset
  end

  def create(conn,%{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok,user} -> 
        conn
        |> Scratch.Auth.login(user)
        |> put_flash(:info, "#{user.name} created")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  defp authenticate(conn, _) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end
  
end
