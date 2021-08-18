defmodule Games.Library do
  defmacro __using__(options) do
    module = Keyword.get(options, :module)

    quote do
     use Agent

      def start_link(file_path) do
        file_path
          |> File.read()
          |> case do
            {:ok, content} ->
              Jason.decode!(content)

            {:error, _} -> []
          end

        Agent.start_link(fn -> [] end, name: __MODULE__)
      end

      def all do
        Agent.get(__MODULE__, fn state -> state end)
      end

      def add(%unquote(module){id: resource_id} = resource) do
        case get(resource_id) do
          nil ->
            Agent.update(__MODULE__, fn state ->
              new_state = [resource | state]

              unquote(module)
              |> Games.Persistence.persist(new_state)

              new_state
            end)

          %unquote(module){} ->
            {:error, :already_exists}
        end
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

      def search_id(id) do
        all() |> Enum.filter(fn game ->
          Map.get(game, :id) == id
        end)
      end

      def search_status(status: status) do
        all() |> Enum.filter(fn game ->
          Map.get(game, :status) =~ status
        end)
      end

      def get(resource_id) do
        Agent.get(__MODULE__, fn state ->
          Enum.find(state, fn resource -> resource.id == resource_id end)
        end)
      end

      def preload(resource) do
        preloaded =
          resource
          |> Map.from_struct()
          |> Enum.filter(fn {key, value} ->
            case value do
              %m{} ->
                m == Games.Store.Association

              _ -> false
            end
          end)
          |> Enum.map(fn {key, value} ->
            module = Module.safe_concat(value.module, Store)

            {key, module.get(value.resource_id)}
          end)
          |> Enum.into(%{})

        Map.merge(resource, preloaded)
      end
    end
  end
end
