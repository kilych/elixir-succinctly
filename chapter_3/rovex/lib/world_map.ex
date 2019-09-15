defmodule WorldMap do
	use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: WorldMap)
  end

  def init([]) do
    {:ok, %{rovers: []}}
  end

  def update_rover(name, x, y) do
    GenServer.call(__MODULE__, {:update_rover, name, x, y})
  end

  def handle_call({:update_rover, name, x, y}, _from, state) do
	  rovers = update_rover_list(state.rovers, name, x, y)

    case Enum.find(rovers, fn r -> r.name != name && r.x == x && r.y == y end) do
      nil -> {:reply, :ok, %{state | rovers: rovers}}
      rover_to_kill -> RoverSupervisor.kill(rover_to_kill)
      new_rovers = List.delete(rovers, rover_to_kill)
      {:reply, :ok, %{state | rovers: new_rovers}}
    end
  end

  defp update_rover_list(rovers, name, x, y) do
    case Enum.find_index(rovers, fn r -> r.name == name end) do
      nil -> rovers ++ [%{name: name, x: x, y: y}]
      index -> List.replace_at(rovers, index, %{name: name, x: x, y: y})
    end
  end
end
