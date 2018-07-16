defmodule RemoteLogging do

  def start(_, _) do
    connect_to_other_nodes()
    Supervisor.start_link([ RemoteLogging.Demo ], strategy: :one_for_one)
  end


  def connect_to_other_nodes() do
    my_host = case node() do
      nil ->
        raise "You have to start with --name"
      name ->
        name
        |> to_string()
        |> String.split("@", parts: 2)
        |> tl()
        |> hd()
    end

    :global.sync()

    Application.get_env(:remote_logging, :connect_to, [])
    |> Enum.each(fn name ->
          IO.inspect { :"#{name}@#{my_host}", Node.connect(:"#{name}@#{my_host}") }
       end)

  end

end
