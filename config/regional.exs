use Mix.Config

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


# The following is not part of bunyan. It allows you to start and stop the
# various components of this particular demo and not worry about connecting the
# nodes manually.

config :remote_logging,
       connect_to: [
         :local,
         :global,
       ]
