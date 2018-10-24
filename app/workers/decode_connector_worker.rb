class DecodeConnectorWorker
  include Sidekiq::Worker

  def perform(*args)
    path = Rails.application.secrets.decode.connector_path
    output = `echo hola mundo`
  end
end
