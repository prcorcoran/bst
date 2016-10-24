class Verse < ActiveRecord::Base
  has_many :words
  has_one :kjv_bible
  validates_uniqueness_of :verse, :scope => [ :book, :chapter]
end
