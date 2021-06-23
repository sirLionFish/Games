defmodule Games.Router do
  use Plug.Router
  use Plug.ErrorHandler

  plug :match
  plug :dispatch

   get "/" do
    send_resp(conn, 200, "       Welcome to the Library

    URLs:
     _________________________________
    |  /all_gamess   (Show all Games)|
    |  /games/month  (Sort by Month) |
    |  /games/name   (Search by Name)|
    |________________________________|
    ")
  end

  match "/all_games", via: :get do
    render_json(conn, Games.Library.list_games())
  end

  get "/games/:month" do
    game = Games.Library.sort_by_month(month: "#{month}")
    render_json(conn, game)
  end

  get "/game/:name" do
    game = Games.Library.search_name(name: "#{name}")
    render_json(conn, game)
  end

  defp render_json(conn, data) do
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, Jason.encode!(data))
  end

   match _ do
    send_resp(conn, 404, "This Page Simply Does Not Exist")
  end

  defp handle_errors(conn, %{kind: kind, reason: reason, stack: stack}) do
    IO.inspect(kind, label: :kind)
    IO.inspect(reason, label: :reason)
    IO.inspect(stack, label: :stack)
    send_resp(conn, conn.status, "An Error Seemed Have Occur")
  end
end
