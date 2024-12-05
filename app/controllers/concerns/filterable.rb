module Filterable
  extend ActiveSupport::Concern

  def config_filterable?
    params.has_key?(:"entity types") || params.has_key?(:"relation types")
  end
end
