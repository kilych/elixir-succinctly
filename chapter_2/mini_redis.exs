defmodule MiniRedis do
	import GenServer

  def init(_) do
    {:ok, %{}}
  end

  def start_link(opts \\ []) do
    # as mentored on p.51 but doesn't work
    # GenServer.start_link(__MODULE__, [], opts)
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  def set(key, value) do
    GenServer.call(__MODULE__, {:set, key, value})
  end

  # # Another option is to use arbitrary name
  # def start_link(opts \\ []) do
  #   GenServer.start_link(__MODULE__, [], name: :mini_redis)
  # end
  #
  # def get(key) do
  #   GenServer.call(:mini_redis, {:get, key})
  # end
  #
  # def set(key, value) do
  #   GenServer.call(:mini_redis, {:set, key, value})
  # end

  def handle_call({:set, key, value}, _from, state) do
    {:reply, :ok, Map.merge(state, %{key => value})}
  end

  def handle_call({:get, key}, _from, state) do
    {:reply, Map.fetch(state, key), state}
  end
end
