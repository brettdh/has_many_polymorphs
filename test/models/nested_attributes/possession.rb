class Possession < ActiveRecord::Base
  def description
    "Possession #{id}"
  end
  
  def modify
    self
  end
end
