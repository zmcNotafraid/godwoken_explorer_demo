defmodule GodwokenExplorerWeb.Notifier do
  @moduledoc """
  Responds to events by sending appropriate channel updates to front-end.
  """

  alias GodwokenExplorerWeb.Endpoint

  def handle_event({:chain_event, :blocks, :realtime, block}) do
    broadcast_block(block)
  end

  def handle_event(_), do: nil

  defp broadcast_block(block) do
    Endpoint.broadcast("blocks:new_block", "new_block", %{
      block: block
    })
  end

end
