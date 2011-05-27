ActiveRecord::Base.class_eval do  
  def self.validates_email(options={})  
    validates_format_of :email, 
      options.merge(:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i)
  end 
end 

