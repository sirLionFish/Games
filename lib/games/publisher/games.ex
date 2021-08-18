defmodule Games do
  @derive Jason.Encoder
  defstruct [:id, :name, :month, :publisher, :status]
  defmodule Store do
    use Games.Library, module: Games
  end

  def new(name: name, month: month, publisher: publisher, status: status) do
    %__MODULE__{
      id: UUID.uuid4(),
      name: name,
      month: month,
      publisher: publisher,
      status: status}
  end
end
