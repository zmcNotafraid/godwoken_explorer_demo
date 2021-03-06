defmodule GodwokenExplorer.Chain.Events.Publisher do
  @moduledoc """
  Publishes events related to the Chain context.
  """

  def broadcast(_data, false), do: :ok

  def broadcast(data, broadcast_type) do
    for {event_type, event_data} <- data do
      send_data(event_type, broadcast_type, event_data)
    end
  end

  @spec broadcast(atom()) :: :ok
  def broadcast(event_type) do
    send_data(event_type)
    :ok
  end

  defp send_data(event_type) do
    sender().send_data(event_type)
  end

  defp sender do
    Application.get_env(:godwoken_explorer, :realtime_events_sender)
  end

  # The :catchup type of event is not being consumed right now.
  # To avoid a large number of unread messages in the `mailbox` the dispatch of
  # these type of events is disabled for now.
  defp send_data(_event_type, :catchup, _event_data), do: :ok

  defp send_data(event_type, broadcast_type, event_data) do
    sender().send_data(event_type, broadcast_type, event_data)
  end
end
