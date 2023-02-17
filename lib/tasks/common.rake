# Extend logger to the main object
def logger
  Rails.logger
end

desc "Setup a common setting for every tasks"
task common: %i(environment) do
  Rails.logger = Logger.new(STDOUT)
  if Rails.env.production?
    Rails.logger.level = Logger::INFO
  elsif Rails.env.staging?
    Rails.logger.level = Logger::DEBUG
  else
    Rails.logger.level = Logger::DEBUG
  end
end

desc "Switch the level of a logger to DEBUG"
task debug: %i(common) do
  Rails.logger.level = Logger::DEBUG
end

require 'task_logging'
