use Mix.Config

case node() |> to_string() do

"local" <> _ ->
  import_config "local.exs"

"region" <> _ ->
  import_config "regional.exs"

"global" <> _ ->
  import_config "global.exs"

_ ->
  unless hd(System.argv) =~ ~r/deps\./ do
    IO.puts """

    To run this demo, you need to specify nodes:

        $ iex --name global@127.0.0.1     -S mix run
        $ iex --name regionalal@127.0.0.1 -S mix run
        $ iex --name local@127.0.0.1      -S mix run

    """
    :erlang.halt
  end
end
