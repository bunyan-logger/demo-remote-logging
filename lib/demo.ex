defmodule RemoteLogging.Demo do
  use GenServer

  @me __MODULE__

  def generate(type) do
    GenServer.call(@me, type)
    :timer.sleep(400)  # so the iex prompt doesn't get in the way
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: @me)
  end

  def init(_) do
    { :ok, nil }
  end

  def handle_call(:sample, _, _) do
    require Bunyan
    import Bunyan
    info("Starting database compaction", %{
      database: "prod_orders",
      mode:     :concurrent
    })
    info("1,396 orphaned carts found")
    warn("These carts have referrers and cannot be deleted:",
    [ 48792, 49352, 49720, 50155, 57782 ])
    error("This cart is locked and cannot be deleted",
    %{ id: 49823, user_id: 2009481, created: "2018-06-14 12:34:56",
       name: "Lisa Simpson", address: nil })
    info("1,391 ophaned carts removed")
    { :reply, nil, nil }
  end

  def handle_call(:badarg, _, _) do
    length(4)
    { :reply, :never_get_here, nil }
  end

  def handle_call(:badarith, _, _) do
    _ = Kernel.+(1, :two)
    { :reply, :never_get_here, nil }
  end

  def handle_call(:badmatch, _, _) do
    :this_is_an_error = :this_does_not_match
    { :reply, :never_get_here, nil }
  end

  def handle_call(:function_clause, _, _) do
    some_function(1)
    { :reply, :never_get_here, nil }
  end

  def handle_call(:case_clause, _, _) do
    case 1 do
      0 -> nil
    end
    { :reply, :never_get_here, nil }
  end

  def handle_call(:try_clause, _, _) do
    { :reply, "I don't think Elixir generates this", nil }
  end


  def handle_call(:if_clause, _, _) do
    { :reply, "We can't generate this in Elixir", nil }
  end

  def handle_call(:undef, _, _) do
    spawn_link(A, :b, [1])
    { :reply, "We can't generate this in Elixir", nil }
  end

  # def error_detail({ :badfun, f }),
  # do: "Error with function «#{inspect f}».\n(perhaps you're using a variable in a context that needs a function?)"

  # def error_detail({ :badarity, f }),
  # do: "Function «#{inspect f}» is called with the wrong number of arguments"

  # def error_detail(:timeout_value),
  # do: "Timeout value in a `receive` is not an integer"

  # def error_detail(:noproc),
  # do: "Tried to link to a nonexistent process"

  # def error_detail({ :nocatch, value }),
  # do: "`throw(#{inspect value}) called, but no matching `catch`"

  # def error_detail(:system_limit),
  # do: "A system limit has been exceeded"


  defp some_function(0), do: 0

end
