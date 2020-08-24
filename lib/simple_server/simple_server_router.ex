defmodule SimpleServer.Router do
  # Use Plug to talk to Cowboy
  use Plug.Router
  use Plug.Debugger
  require Logger

  plug(Plug.Logger, log: :debug)

  plug(:match)

  plug(:dispatch)

  # Simple GET
  get "/hello" do
    # conn Struct is from Plug, as request information
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello world")
  end

  # Basic example to handle POST requests wiht a JSON body
  post "/post" do
    # read_body is also from Plug, it will break down the request
    {:ok, body, conn} = read_body(conn)

    # decode JSON
    body = Poison.decode!(body)

    IO.inspect(body) # Print body

    send_resp(conn, 201, "created: #{get_in(body, ["message"])}")
  end

  # "Default" route that will get called when no other route is matched
  match _ do
    send_resp(conn, 404, "not found")
  end

end