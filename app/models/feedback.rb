class Feedback < ActiveRecord::Base    

  validates_presence_of :email, :content
  
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "should look like: someone@domain.com", :allow_blank => true
  validates_length_of :content, :within => 6..2000, :allow_blank => true                      
  
  cattr_reader :per_page
  @@per_page = 10

end