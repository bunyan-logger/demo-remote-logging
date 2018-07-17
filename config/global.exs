use Mix.Config

config :bunyan,
       read_from: [
         Bunyan.Source.Api,
         Bunyan.Source.ErlangErrorLogger,
         {
           Bunyan.Source.RemoteReader,
             global_name: :global_logger,
         },
       ],
       write_to: [
        { Bunyan.Writer.Device, name: :console_logger },
        {
          Bunyan.Writer.Device,
              name:          :error_log_writer,
              device:        "./error.log",
              pid_file_name: "./error_log_writer.pid",
        },
       ]

       # The following is not part of bunyan. It allows you to start and stop the
# various components of this particular demo and not worry about connecting the
# nodes manually.

config :remote_logging,
       connect_to: [
         :local,
         :regional,
       ]
