defmodule Rover.Web.Router do
	use Plug.Router

  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  plug(:match)
  plug(:dispatch)

  get "/ping" do
    send_resp(conn, 200, Poison.encode!(%{message: "pong"}))
  end

  post "/rover" do
    rover_name = conn.body_params["name"]
    x = conn.body_params["x"]
    y = conn.body_params["y"]
    direction = String.to_atom(conn.body_params["direction"])

    case RoverSupervisor.create_rover(rover_name, x, y, direction) do
      {:ok, _
      } -> send_resp(conn, 201, Poison.encode!(%{message: "created rover #{rover_name}"}))
      {:error, {:already_started, _}
      } -> send_resp(conn, 400, Poison.encode!(%{message: "rover #{rover_name} already exists"}))
      _ -> send_resp(conn, 500, Poison.encode!(message: "generic error"))
    end
  end

  # post "/command" do
  #   rover_name = conn.body_params["name"]
  #   command = String.to_atom(conn.body_params["command"])
  #
  #   case apply(Rover, command, [rover_name]) do
  #     {:reply, res, _} -> send_resp(conn, 200, Poison.encode!(res))
  #     {:noreply, new_state
  #     } -> send_resp(conn, 201, Poison.encode!(new_state))
  #     _ -> send_resp(conn, 400, Poison.encode!(%{message: "unknown command #{command}"}))
  #   end
  # end

  post "/command" do
    rover_name = conn.body_params["name"]
    command = String.to_atom(conn.body_params["command"])
    Rover.send_command(rover_name, command)
    send_resp(conn, 204, Poison.encode!(%{}))
  end

  match(_) do
    send_resp(conn, 404, "")
  end
end
