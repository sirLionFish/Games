defmodule Games.Library do
  use Agent

  def start_link(_games) do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  #%{games => games}
  def list_games do
    Agent.get(__MODULE__, &Keyword.values/1)
  end

  def add_game(game) do
    Agent.update(__MODULE__, &(Keyword.put(&1, game.id, game)))
  end

  def search(game_id) do
    Agent.get(__MODULE__, &(Map.get(&1, game_id)))
  end

  def search_name(name: name) do
    list_games() |> Enum.filter(fn game ->
      Map.get(game, :name) =~ name
    end)
  end

  def sort_by_month(month: month) do
    list_games() |> Enum.filter(fn game ->
      Map.get(game, :month) =~ month
    end)
  end

  def sort_by_publishers(publisher: publisher) do
    list_games() |> Enum.filter(fn game ->
      Map.get(game, :publisher) == publisher
    end)
  end

  def remove_game(game) do
    Agent.update(__MODULE__, &(Map.delete(&1, game.id)))
  end

  def edit(game_id, params) do
    Agent.get(__MODULE__, &(Map.get_and_update(&1, game_id, params)))
  end
end
