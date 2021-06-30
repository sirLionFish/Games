defmodule Games.Library do
  use Agent

  def start_link(_games) do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def all do
    Agent.get(__MODULE__, fn state -> state end)
  end

  def add(game) do
    Agent.update(__MODULE__, fn state -> [game | state] end)
  end

  def search_name(name: name) do
    all() |> Enum.filter(fn game ->
      Map.get(game, :name, name) =~ name
    end)
  end

  def search_by_month(month: month) do
    all() |> Enum.filter(fn game ->
      Map.get(game, :month) =~ month
    end)
  end

  def search_by_publishers(publisher: publisher) do
    all() |> Enum.filter(fn game ->
      Map.get(game, :publisher) =~ publisher
    end)
  end

  def search_id(id: id) do
    all() |> Enum.filter(fn game ->
      Map.get(game, :id) == id
    end)
  end
end
