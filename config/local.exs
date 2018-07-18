use Mix.Config

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

# The following is not part of bunyan. It allows you to start and stop the
# various components of this particular demo and not worry about connecting the
# nodes manually.

config :remote_logging,
       connect_to: [
         :regional,
         :global,
      ]
