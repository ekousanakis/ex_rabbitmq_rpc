defmodule ExRabbitMQ.RPC.Client.RequestTracking do
  @moduledoc false

  @key __MODULE__

  def get_delete(correlation_id) do
    case process_get() do
      %{^correlation_id => from} = data ->
        Map.delete(data, correlation_id) |> process_set()

        {:ok, from}

      _ ->
        {:error, :no_request_tracking}
    end
  end

  def set(_correlation_id, nil), do: :ok

  def set(correlation_id, from) do
    process_get() |> Map.put(correlation_id, from) |> process_set()

    :ok
  end

  defp process_get, do: Process.get(@key, Map.new())

  defp process_set(data), do: Process.put(@key, data)
end
