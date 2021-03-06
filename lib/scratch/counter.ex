defmodule Scratch.Counter do
  use GenServer
  
  def inc(pid), do: GenServer.cast(pid, :inc)

  def dec(pid), do: GenServer.cast(pid, :dec)

  def val(pid, timeout \\ 5000) do
    GenServer.cast(pid, :val)
  end

  def start_link(initial_val) do
    GenServer.start_link(__MODULE__, initial_val)
  end

  def init(initial_val) do
    {:ok, initial_val}
  end

  def handle_cast(:inc, val) do
    {:noreply, val + 1}
  end

  def handle_cast(:dec, val) do
    {:noreply, val - 1}
  end
  
  def handle_case(:val, _from, val) do
    {:reply, val, val}
  end 

end
