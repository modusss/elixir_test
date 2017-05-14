#this plug was made to be like 'pundit' in rails

defmodule Discuss.Plugs.RequireAuth do

  import Plug.Conn # gives us the 'halt' function
  import Phoenix.Controller # gives us 'put_flash' and 'redirect'
  alias Discuss.Router.Helpers # gives us a single function 'Helpers.topic_path()'

  # this function will be executed only one time
  # so we require but doesn't use it directly
  def init(_params) do
  end

  # this 'params' is whatever that is returned from the 'init' function
  def call(conn,_params) do
    # Is there a user signed in ?
    if conn.assigns[:user] do
      # 'hey, fantastic...go on and continue whatever you want'
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in.")
      |> redirect(to: Helpers.topic_path(conn, :index))
      # 'everything is done, send back to the user and don't hand this again with another plugs
      |> halt()
    end

  end
end
