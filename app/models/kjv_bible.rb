class KjvBible < ActiveRecord::Base
  belongs_to :verse
  def self.table_name() "kjv_bible" end
end
