defmodule Games.Platform do
   @derive Jason.Encoder
  defstruct [:id, :platform]

  defmodule Store do
    use Games.Library, module: Games.Platform
  end

  def new(platform: platform) do
    %__MODULE__{
      id: UUID.uuid4(),
      platform: platform
    }
  end

  def show(platform) do
    [
      Games.Platform.Store.search_platform(platform: platform),
      Games.Publisher.Store.search_platform(platform: platform),
      Games.Store.search_platform(platform: platform)
    ]
  end
end
