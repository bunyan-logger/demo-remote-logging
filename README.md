# Remote Logging

A simple demo of remote logging using the
[Bunyan](https://github.com/bunyan-logger/bunyan) logger.

First, fetch dependencies.

    # mix deps.get

Open three terminals in this directory.

In the first, issue the following command:

    $ iex --name global@127.0.0.1 -S mix run

(You will get 4 warnings when the `demo.ex` module compiles. That's
because it deliberately contains code that will cause runtime errors.)

In the second terminal, run

    $ iex --name regional@127.0.0.1 -S mix run

And finally, in the third

    $ iex --name local@127.0.0.1 -S mix run

The node names are important, as they help the demo configure the
logger.

## OK, Now What

Go the the terminal that's running the local node, and keep the other
two windows visible.

In the local iex session, run

~~~ elixir
iex> require Bunyan
iex> import  Bunyan
iex> debug  "a debug message in local"
iex> info   "and then an info message", answer: 42, helpful: false
iex> warn   "don't panic"
iex> error  fn -> System.user_home end, args: System.argv
~~~

and watch the log messages appear.

Do the same in the other sessions.

## What You Just Configured

We now have three applications running, each on its own node.

* The `local` node is configured to write its log messages to the
  console, and also to forward messages at the info level or greater to
  the `regional` node. Here's its configuration:

  ~~~ elixir
  config :bunyan,
        read_from: [
          Bunyan.Source.Api,
          Bunyan.Source.ErlangErrorLogger,
        ],
        write_to: [
          Bunyan.Writer.Device,
          {
            Bunyan.Writer.Remote,
              runtime_log_level: :info,
              send_to:           :regional_logger,
          },
       ]
  ~~~

* The `regional` node also writes its log messages to the console. It is
  also configured to received messages from `local`, so it will log
  these as well. Finally, the regional node forwards all `:warn` and
  `:error` messages to the global node.

  ~~~ elixir
  config :bunyan,
         read_from: [
           Bunyan.Source.Api,
           Bunyan.Source.ErlangErrorLogger,
           {
             Bunyan.Source.RemoteReader,
                 global_name: :regional_logger,
           },
         ],
         write_to: [
           Bunyan.Writer.Device,
           {
             Bunyan.Writer.Remote,
               runtime_log_level: :warn,
               send_to:           :global_logger,
               send_to_nodes: [
                   :"global@127.0.0.1",
                   :"global1@127.0.0.1",
               ],
           },
         ]
  ~~~


* The `global` node reports all its messages to the console, and logs
  `:error` level messages to the file `./error.log`.

  ~~~ elixir
  config :bunyan,
         read_from: [
           Bunyan.Source.Api,
           Bunyan.Source.ErlangErrorLogger,
           { Bunyan.Source.RemoteReader, global_name: :global_logger }
         ],
         write_to: [
           { Bunyan.Writer.Device, name: :console_logger },
           {
             Bunyan.Writer.Device,
                 name:     :error_log_writer,
                 path:     "./error.log",
                 pid_file: "./error_log_writer.pid",
           },
         ]
  ~~~

![diagram showing the three nodes and the messages displayed and saved
on each](./assets/images/bunyan-demo-flow.svg)


## And Then...

While the three nodes are running, start another global node. You'll need
to call it `global1` (or anything else starting "global").


    $ iex --name global1@127.0.0.1 -S mix run

Back in the local node, generate some log messages: you should see them
appear in both global nodes.


### The Regional and Global Loggers Seem to Lag...

Good eye! When you use a remote logger, Bunyan attempts to reduce
network overhead by batching log messages. What you're seeing is the
default 200ms batching timeout. You can adjust both this timeout and the
maximum batch size in the configuration.

## Next Steps...

* To see how this is configured, have a look at `local.exs`,
  `regional.exs`, and `global.exs` in the `config/` directory.

* To use the Bunyan logger in your application, have a look at the
  [documentation](https://github.com/bunyan-logger/bunyan/blob/master/README.md).

* Bunyan is designed to be extended using plugins. You can add new
  sources of log messages (it comes with sources that p rovide a
  programmatic API, and interface to the Erlang error logger, and a
  source that recieves remote log messages). It also comes with writers
  that write to devices (files and the console) and to other logger
  nodes).

  It's easy to add your own sources and writers: see the documentation.

  # TODO: missing link
