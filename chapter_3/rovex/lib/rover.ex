defmodule Rover do
	use GenServer

  @world_width 100
  @world_height 100

  defstruct [:x, :y, :direction, :name] 

  def start_link({x, y, d, name}) do
    # Better start it supervised!
    Registry.start_link(keys: :unique, name: Rover.Registry)

    GenServer.start_link(__MODULE__, {x, y, d, name}, name: RegistryHelper.create_key(name))
  end

  def init({x, y, d, name}) do
    {:ok, %Rover{x: x, y: y, direction: d, name: name}}
  end

  def get_state(name) do
    GenServer.call(RegistryHelper.create_key(name), :get_state)
  end

  def go_forward(name) do
    GenServer.cast(RegistryHelper.create_key(name), :go_forward)
  end

  def rotate_left(name) do
    GenServer.cast(RegistryHelper.create_key(name), :rotate_left)
  end

  def rotate_right(name) do
    GenServer.cast(RegistryHelper.create_key(name), :rotate_right)
  end

  def handle_call(:get_state, _from, state) do
	  {:reply, {:ok, {state.x, state.y, state.direction}}, state}
  end

  def handle_cast(:go_forward, state) do
	  new_state = case state.direction do
              :N -> %Rover{state | y: rem(state.y + 1, @world_height)}
              :S -> %Rover{state | y: rem(state.y - 1 + @world_height, @world_height)}
              :E -> %Rover{state | x: rem(state.x + 1, @world_width)}
              :W -> %Rover{state | x: rem(state.x - 1 + @world_width, @world_width)}
	  end

    {:noreply, new_state}
  end

  def handle_cast(:rotate_left, state) do
	  new_state = case state.direction do
                  :N -> %Rover{state | direction: :W}
                  :W -> %Rover{state | direction: :S}
                  :S -> %Rover{state | direction: :E}
                  :E -> %Rover{state | direction: :N}
	              end

    {:noreply, new_state}
  end

  def handle_cast(:rotate_right, state) do
	  new_state = case state.direction do
                  :N -> %Rover{state | direction: :E}
                  :E -> %Rover{state | direction: :S}
                  :S -> %Rover{state | direction: :W}
                  :W -> %Rover{state | direction: :N}
	              end

    {:noreply, new_state}
  end
end
