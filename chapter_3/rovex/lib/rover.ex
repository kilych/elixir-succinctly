defmodule Rover do
	use GenServer

  @world_width 100
  @world_height 100

  defstruct [:x, :y, :direction, :name] 

  def init({x, y, d, name}) do
    {:ok, %Rover{x: x, y: y, direction: d, name: name}}
  end

  def start_link({x, y, d, name}) do
    GenServer.start_link(__MODULE__, {x, y, d, name}, name: String.to_atom(name))
  end

  def get_state(name) do
    GenServer.call(String.to_atom(name), :get_state)
  end

  def handle_call(:get_state, _from, state) do
	  {:reply, {:ok, {state.x, state.y, state.direction}}, state}
  end

  def handle_cast(:go_forward, state) do
	  new_state = case state.direction do
              :N -> %Rover{state | y: rem(state.y + 1, @world_height)}
              :S -> %Rover{state | y: rem(state.y - 1, @world_height)}
              :E -> %Rover{state | x: rem(state.x + 1, @world_width)}
              :W -> %Rover{state | x: rem(state.x - 1, @world_width)}
	  end

    {:noreply, new_state}
  end
end
