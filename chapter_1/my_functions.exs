defmodule MyFunctions do
  def sum(x, y) do
    x + y
  end

  def sum(a, b, c), do: a + b + c

  def sub(x) do
    -x
  end

  def sub(x, y) do
    x - y
  end

  def print_result(f) do
    IO.puts(f.())
  end
end

MyFunctions.sum(1, 23)

defmodule DoSomeMath do
	import MyFunctions

  def add_and_substract(a, b, c) do
    sub(sum(a, b), c)
  end
end

defmodule DoImport do
	import MyFunctions, only: [sum: 2]
end

defmodule Bot do
	def gree("") do
    IO.puts "None to greet."
	end

  def greet(name) do
    IO.puts "Hello #{name}"
  end
end

defmodule Factorial do
	def do_it(0) do
    1
	end

  def do_it(n) do
    n * do_it(n - 1)
  end

  def do_it_proper(n) do
    internal_do_it(n, 1)
  end

  defp internal_do_it(0, acc) do
    acc
  end

  defp internal_do_it(n, acc) do
	  internal_do_it(n - 1, acc * n)
  end
end

defmodule ListUtils do
	def sum([]) do
    0
	end

  def sum([h | t]) do
    h + sum(t)
  end
end

defmodule Foo do
	def divide_by_10(value) when value > 0 do
    value / 10
	end
end

defmodule Math do
  @spec sum(integer, integer) :: integer
  def sum(a, b) do
    a + b
  end

  @spec div(integer, integer) :: {:ok, integer} | {:error, String.t}
  def div(a, b) do
    a / b
  end
end

defmodule Customer do
	@type entity_id() :: integer()

  @type t :: %Customer{id: entity_id(), first_name: String.t, last_name: String.t}
  defstruct id: 0, first_name: nil, last_name: nil
end

defmodule CustomerDao do
  @type reason :: String.t
  @spec get_customer(Customer.entity_id()) :: {:ok, Customer} | {:error, reason}
  def get_customer(id) do
    # ...
    IO.puts "GETTING CUSTOMER"
  end
end

defprotocol Printable do
	def to_csv(data)
end

defimpl Printable, for: Map do
	def to_csv(map) do
    map
    |> Map.values()
    |> Enum.join(",")
	end
end

defimpl Printable, for: List do
	def to_csv(list) do
    list |> Enum.map(&Printable.to_csv/1)
	end
end

defimpl Printable, for: Integer do
	def to_csv(int) do
    to_string(int)
	end
end

defmodule TalkingAnimal do
	@callback say(what :: String.t) :: {:ok}
end

defmodule Cat do
	@behaviour TalkingAnimal
  def say(str) do
    "miaooo"
  end
end

defmodule Dog do
	@behaviour TalkingAnimal
  def say(what) do
	  "woff"
  end
end

defmodule Factory do
	def get_animal() do
    # can get module from configuration file
    Cat
	end
end

defmodule Logger do
	defmacro log(msg) do
	  if is_log_enabled() do
      quote do
	      IO.puts("> From log: #{unquote(msg)}")
      end
	  end
  end
  
  def is_log_enabled(), do: true
end
