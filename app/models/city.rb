class City < ActiveRecord::Base
  belongs_to :country
  def self.table_name() "lu_cities" end
end
