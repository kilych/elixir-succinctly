defmodule AsyncMath do
	def start() do
    receive do
	    {:sum, [x, y], pid} ->
		    send(pid, {:result, x + y})
    end
    start()
	end
end

pid = spawn(AsyncMath, :start, [])
send pid, {:sum, [5, 6], self}

receive do
  {:result, x} -> IO.puts x
end

