defmodule Games.Pub do
  @derive Jason.Encoder
  defstruct [:id, :name, :year, :location, :platform]
  defmodule Store do
    use Games.Library, module: Games.Pub
  end

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
