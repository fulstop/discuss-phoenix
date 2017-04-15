defmodule Discuss.TopicController do
  use Discuss.Web, :controller
  alias Discuss.Topic

  def index(conn, _params) do
    topics = Repo.all(Topic)
    render(conn, "index.html", topics: topics)
  end

  def show(conn, params) do
    %{"id" => id} = params
    topic = Repo.get(Topic, id)
    render(conn, "show.html", topic: topic)
  end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def edit(conn, params) do
    %{"id" => id} = params
    topic = Repo.get(Topic, id)
    changeset = Topic.changeset(topic)
    render(conn, "edit.html", topic: topic, changeset: changeset)
  end

  def create(conn, params) do
    %{"topic" => topic_params} = params
    changeset = Topic.changeset(%Topic{}, topic_params)

    case Repo.insert(changeset) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Saved!")
        |> redirect(to: "/")
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def update(conn, params) do
    %{"id" => id, "topic" => topic_params} = params
      topic = Repo.get(Topic, id)
      changeset = Topic.changeset(topic, topic_params)

    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Saved!")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", topic: topic, changeset: changeset)
    end
  end
end
