defmodule Games.Store.Association do
  defstruct [:resource_id, :module]

  def new(%m{id: resource_id}) do
  	%__MODULE__{
		  resource_id: resource_id,
      module: m
		}
  end
end
