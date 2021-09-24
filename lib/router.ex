defmodule Games.Router do
  use Plug.Router
  use Plug.ErrorHandler

  plug(:match)
  plug Plug.Parsers,
  parsers: [:json],
  pass:  ["application/json"],
  json_decoder: Jason
  plug(:dispatch)


  plug :match
  plug :dispatch

   get "/" do
    send_resp(conn, 200, "       Welcome to the Library

    URLs:
     _________________________________________
    |  /game/all       (Show all Games)       |
    |  /month/:month   (Lists by Month)       |
    |  /name/:name     (Search by Name)       |
    |  /status/:status (Search by Status)     |
    |  /publisher/all  (Search by Publisher)  |
    |_________________________________________|
    ")
  end

  match "/game/all", via: :get do
    render_json(conn, Games.Store.all())
  end

  get "/month/:month" do
    game = Games.Store.search(month: "#{month}")
    render_json(conn, game)
  end

  get "/name/:name" do
    game = Games.Store.search(name: "#{name}")
    render_json(conn, game)
  end

  get "/status/:status" do
    game = Games.Store.search(status: "#{status}")
    render_json(conn, game)
  end

  # post "/library/game" do
  #   game_params = conn.params["game"]
  #   game = %Games{
  #     name: game_params["name"],
  #     publisher: game_params["publisher"],
  #     month: game_params["month"]
  #   }
  #   {:ok, added_book} = Games.Repo.insert(game)
  #   render_json(conn, added_book)
  # end

  post "/games/library" do
    %{"game" => building_params} = conn.params
    game = Games.new(building_params)

    case Games.Store.add(game) do
      :ok ->
        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(201, Jason.encode!(game))

      _ ->
        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(422, Jason.encode!(%{data: %{error: "something failed :/"}}))
    end
  end

  get "/publisher/all" do
    render_json(conn, Games.Publishers.show_all())
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
    send_resp(conn, conn.status, "Doesn't Seem to work :/")
  end
end
