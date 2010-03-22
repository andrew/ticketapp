class Ticket < ActiveRecord::Base

  validates_presence_of :content, :user_id
  validates_length_of :content, :within => 3..10000, :allow_blank => true
  
  belongs_to :user
  
  belongs_to :ticket, :class_name => "Ticket", :foreign_key => "reply_id"
  has_many :replies, :class_name => "Ticket", :foreign_key => "reply_id"
  
  cattr_reader :per_page
  @@per_page = 10

  has_finder :recent, :limit => 50
  has_finder :not_private, :conditions => ["private = ?", false]
  has_finder :newest_first, :order => "created_at DESC"
    
end
