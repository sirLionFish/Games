defmodule Games.Publisher do
  defstruct [:id, :name, :founded, :headquarter, :game]

  defmodule Store do
    use Games.Library, module: Games.Publisher
  end

  def new(%Games{} = game, %{name: name, founded: founded, headquarter: headquarter}) do
    %__MODULE__{
      id: UUID.uuid4(),
      name: name,
      founded: founded,
      headquarter: headquarter,
      game: Games.Store.Association.new(game)
    }
  end
end
