defmodule Discuss.TopicController do
  # use is like a way to have the methods from Discuss.Web to controller section
  use Discuss.Web, :controller

  # conn -> conection
  # a struct of elixir with many informations about the request
  # params -> parameters

  alias Discuss.Topic

  def index(conn, _params) do
    # because we inherited with 'alias', we don't need to put:
    # topics = Discuss.Repo.all(Discuss.Topic)   #(but we can test it on the terminal with 'iex -S mix')
    topics = Repo.all(Topic)
    # render this template and make 'topics' available with the variable 'topics'
    render conn, "index.html", topics: topics
  end

  # we put '_' with params because we are not caring about this data at now
  # and to stop the warnning that this variable is unused
  def new(conn,_params) do
    # %Topic{} is the struct (from model)
    # %{} is the params
    changeset = Topic.changeset(%Topic{},%{})
    # changeset: changeset is related to the @changeset in the form to have correlation with the changeset from the model
    # this a way to pass data from controller to view, ex:
    # in controller:
    # sum = 1 + 1
    # render conn, "new.html", sum: sum
    # in view:
    # <%= @sum %> (I get 2)
    # obs: 'conn' is passed automatically for us on 'render'
    render conn, "new.html", changeset: changeset
  end

  # %{"topic" => topic} is a pattern matching
  def create(conn, %{"topic" => topic}) do
    # changeset -> represents the changes we want on the database
    # topic -> a title from whatever came from the form
    # %Topic{} -> an empty struct because we are creating something from scretch (if we were updating, we should pass parameters)
    changeset = Topic.changeset(%Topic{}, topic)
    # bellow we actually insert in the database
    # this function we got from the calling :controller
    case Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic created!")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end

  def edit(conn, %{"id" => topic_id}) do
    # 'Repo.get' gets the particular data out of our database
    topic = Repo.get(Topic, topic_id)
    # then we create a changeset out of that 'topic' that came from the database
    # we created this changeset beaucase all of our form helpers expect to have a changeset inside of them
    changeset = Topic.changeset(topic)
    # we need to send 'topic' variable too because they need to find the 'id' of this record
    render conn, "edit.html", changeset: changeset, topic: topic
  end
  # the params are this pattern matching:
  # id    -> which needs to be updated
  # topic -> the datas received by the form
  def update(conn, %{"id" => topic_id, "topic" => topic}) do
    old_topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(old_topic, topic)
    # it says: I want to update the database with this 'changeset' which carries one particular id
    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Updated")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        render conn, "edit.html", changeset: changeset, topic: old_topic
    end
  end

  # this "id" is referred to the term used on the browser '/id'
  def delete(conn, %{"id" => topic_id}) do
    # the '!' means that we want that returns an error message if somethig goes wrong
    # So 'get!' can say: "hey, that record does not exist!" And 'delete!' can say: "hey, you cannot delete this record!"
    Repo.get!(Topic, topic_id) |> Repo.delete!
    conn
    |> put_flash(:info, "Topic deleted!")
    |> redirect(to: topic_path(conn, :index))
  end

end
