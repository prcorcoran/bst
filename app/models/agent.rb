class Agent < ActiveRecord::Base
#  acts_as_tree :foreign_key => "manager_id"
  
  def manager_full_name
  manager = self.parent
  manager_full_name = ''
  manager_full_name = manager.first_name + manager.last_name unless manager == nil
  manager_full_name
  end 

end
