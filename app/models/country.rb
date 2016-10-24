class Country < ActiveRecord::Base
  has_many :cities
  def self.table_name() "lu_countries" end
  def methoda
    "method_a"
    end
end
