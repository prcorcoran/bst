#This abstract superclass provides a mechanism to cache the lookup tables
#for fast retreival. These are small static tables and the whole table is read
#and cached in the class variable @@cachedInstances for the duration of the 
#instance of the Ruby interpreter. This means that in developement, because the
#Ruby interpreter is loaded on every request, the tables will be reloaded for
#every request. However, in production this speeds things up nicely by reading 
#these tables just once.
class LookupTables < ActiveRecord::Base
require 'raa_ordered_hash'

    self.abstract_class = true
    @@cachedInstances = {}

    #Answer the cached instances for the subclass. Populate the hash by reading
    #the database if this is the first access.
    def self.cached_instances
      if @@cachedInstances[self] == nil
          hash = (@@cachedInstances[self] = RaaOrderedHash.new)
          self.all.order(:id).each do | instance |
            hash[instance.id] = instance
          end
       end
       @@cachedInstances[self]
    end

    #Answer the instance for this id
    def self.getCode id
       cached_instances[id]
    end
     
end
