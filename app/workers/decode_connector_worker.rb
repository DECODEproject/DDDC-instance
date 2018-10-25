class DecodeConnectorWorker
  include Sidekiq::Worker

  def perform(action)
    path = Rails.application.secrets.decode[:connector_path]
    output = `cd #{path} && make #{action}`
    puts output
  end
end
