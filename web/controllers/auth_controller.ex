defmodule Discuss.AuthController do
  use Discuss.Web, :controller
  alias Discuss.User
  plug Ueberauth

  def callback(conn, _params) do
    %{assigns: %{ueberauth_auth: auth}} = conn
    user_params = %{
      token: auth.credentials.token,
      email: auth.info.email,
      provider: "github"
    }

    changeset = User.changeset(%User{}, user_params)
    sign_in(conn, changeset)
  end

  def logout(conn, _params) do
    conn
    |> put_session(:user_id, nil)
    |> redirect(to: topic_path(conn, :index))
  end

  defp sign_in(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> redirect(to: topic_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: topic_path(conn, :index))
    end
  end

  defp insert_or_update_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil -> Repo.insert(changeset)
      user -> {:ok, user}
    end
  end
end
