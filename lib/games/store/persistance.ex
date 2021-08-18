defmodule Games.Persistence do
  def load(module) do
    path(module)
    |> File.read()
    |> case do
      {:ok, content} ->
        content
        |> Jason.decode!()
        |> Enum.map(fn param ->
          param
          |> Enum.map(fn {key, value} ->
            {String.to_existing_atom(key), value}
          end)
          |> Enum.into(%{})

        end)

        |> Enum.map(fn param ->
          struct(module, param)
        end)

      {:error, _} -> []
    end
  end

  def persist(module, content) do
    path(module)
    |> File.write(Jason.encode!(content))
  end

  defp path(module) do
    module_name =
      Macro.underscore(module)
      |> String.split("/")
      |> List.last()

    Application.app_dir(:games)
    |> Path.join("priv/stores/#{module_name}.json")
  end
end