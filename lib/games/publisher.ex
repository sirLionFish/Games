defmodule Games.Publisher do
  use Agent
  alias Games.Library

  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def all do
    Agent.get(__MODULE__, fn state -> state end)
  end

  defp filter_game(publisher: publisher) do
    Library.all() |> Enum.filter(fn game ->
      Map.get(game, :publisher, publisher) =~ publisher
    end)
  end

  def add_game(publisher) do
    info = filter_game(publisher: publisher)
    Agent.update(__MODULE__, fn(state) ->
      Map.update(state, publisher, [info], &(&1 ++ [info]))
    end)
  end

  def search_by_publishers(publisher: publisher) do
    all() |> Enum.filter(fn game ->
      Map.get(game, :publisher) =~ publisher
    end)
  end
end
