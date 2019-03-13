require 'decidim/petitions/decode_connector'

class DecodeConnectorWorker
  include Sidekiq::Worker

  def perform(petition_id)
    petition = Decidim::Petitions::Petition.find petition_id
    connector = Decidim::Petitions::DecodeConnector.new(petition)
    connector.main
  end
end
