defmodule Games.Publishers do
  use Agent
  alias Games.Store

  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def show_all do
    Agent.get(__MODULE__, fn state -> state end)
  end

  defp filter_game(publisher: publisher) do
    Store.all() |> Enum.filter(fn game ->
      Map.get(game, :publisher) =~ publisher
    end)
  end

  def create_publisher(publisher) do
    info = filter_game(publisher: publisher)
    Agent.update(__MODULE__, fn(state) ->
      Map.update(state, publisher, [info], &(&1 ++ [info]))
    end)
  end
end
