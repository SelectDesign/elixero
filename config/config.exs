import Config

if File.exists?(Path.join(__DIR__, "xero_app_config.exs")) do
  import_config "xero_app_config.exs"
end
