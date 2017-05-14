defmodule Discuss.AuthController do
  use Discuss.Web, :controller
  plug Ueberauth

  alias Discuss.User

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    user_params = %{token: auth.credentials.token, email: auth.info.email, provider: "github"}
    # this changeset put our user into the database
    changeset = User.changeset(%User{}, user_params)
    signin(conn, changeset)
  end

  def signout(conn, _params) do
    conn
    # remove the user and it's id from this session
    # obs: we could use 'put_session(nil, nil)'
    |> configure_session(drop: true)
    |> redirect(to: topic_path(conn, :index))
  end

  defp signin(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        # handling cookies to sign in
        # whenever the user persisted in the databse we wanna get the user session
        # so I gonna expect that any user singn in to have some data in their cookies
        # tight specifically to our domain of 'user_id' and it should have a value of the id it is (user.id)
        |> put_session(:user_id, user.id)
        |> redirect(to: topic_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: topic_path(conn, :index))
    end
  end

# a private function because I want that it can only be used by this AuthController module
  defp insert_or_update_user(changeset) do
    # search on User model this email
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset) #this method can return {:error, message} or {:ok, user}
      user ->
        {:ok, user}
    end
  end
end
