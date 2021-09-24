defmodule Games.Publisher do
  @derive Jason.Encoder
defstruct [:id, :name, :year, :location, :platform]
  defmodule Store do
    use Games.Library, module: Games.Publisher
  end

  # def new(%Games{} = game, %{name: name, year: year, location: location, platform: platform}) do
  #   %__MODULE__{
  #     id: UUID.uuid4(),
  #     name: name,
  #     year: year,
  #     location: location,
  #     platform: platform,
  #     game: Games.Store.Association.new(game)
  #   }
  # end

   def new(name: name, year: year, location: location, platform: platform) do
    %__MODULE__{
      id: UUID.uuid4(),
      name: name,
      year: year,
      location: location,
      platform: platform}
  end

  def show(publisher) do
    [
      Games.Publisher.Store.search(name: publisher),
      Games.Store.search(publisher: publisher)
    ]
  end
end
