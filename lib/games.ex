defmodule Games do
   @derive Jason.Encoder
  defstruct [:id, :name, :month, :publisher, :status]
end
