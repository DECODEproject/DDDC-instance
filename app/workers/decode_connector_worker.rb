class DecodeConnectorWorker
  include Sidekiq::Worker

  def perform(*args)
    path = Rails.application.secrets.decode[:connector_path]
    output = `cd #{path} && make create`
  end
end
