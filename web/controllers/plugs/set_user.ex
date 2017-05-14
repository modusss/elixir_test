# look at the user connection
# to grab the id of the session
# to fetch our user on the database
# and to a tiny transform of the connection object
# and set the user model on that connection object
# so any other following plug, any controller in the future, any function anywhere
# we will automatically have use access to the user model on the conn object

defmodule Discuss.Plugs.SetUser do
  import Plug.Conn
  import Phoenix.Controller

  alias Discuss.Repo
  alias Discuss.User

  # look at the connection object
  # see if there is a user id, if there is
  # we want to fetch the user at on our database
  # and assign it to the conn

  def init(_params) do
  end

  # we're taking the connection
  # we attempt to find the user
  # once we find it, we assign to the connection object
  def call(conn, _params) do
    user_id = get_session(conn, :user_id)
    # Repo.get(User, user_id) is gonna to return a user to us
    # if there is a user, and the user_id exists, there will be assigned
    # the user to 'user' variable
    cond do
      user = user_id && Repo.get(User, user_id) ->
        assign(conn, :user, user)
      true ->
        assign(conn, :user, nil)
    end
  end
end
