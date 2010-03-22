require 'digest/sha1'
require 'has_finder'
class User < ActiveRecord::Base
  
  # TODO upgrade restful authentication
  
  has_finder :recent, :limit => 50, :order => 'created_at DESC'
  has_finder :online_last, :order => "last_login DESC"
  
  attr_accessor :password

  cattr_reader :per_page
  @@per_page = 15
  attr_protected :admin

  has_many :tickets, :dependent => :destroy

  def replies
    Ticket.find_by_sql(["SELECT tickets.* from tickets WHERE tickets.reply_id IN ( SELECT tickets.id FROM tickets  WHERE ((tickets.user_id = ?)) ) ORDER BY created_at DESC", self.id])
  end

  def recent_replies
    Ticket.find_by_sql(["SELECT tickets.* from tickets WHERE tickets.reply_id IN ( SELECT tickets.id FROM tickets  WHERE ((tickets.user_id = ?)) ) ORDER BY created_at DESC LIMIT 50", self.id])
  end

  validates_presence_of     :login, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?, :allow_blank => true
  validates_length_of       :password, :within => 4..40, :if => :password_required?, :allow_blank => true
  validates_confirmation_of :password,                   :if => :password_required?, :allow_blank => true
  validates_length_of       :login,    :within => 3..20, :allow_blank => true
  validates_uniqueness_of   :login, :open_id_url, :email, :case_sensitive => false, :allow_blank => true
  validates_format_of(:email, 
                      :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, 
                      :message=>"should look like: someone@domain.com", :allow_blank => true)
                      
  validates_format_of(:login, 
                      :with => /\A[a-zA-Z][\w\-]+\Z/, 
                      :message=>"should only be made of letters", :allow_blank => true)                    
                      
  before_save :encrypt_password
  before_create :make_activation_code 

  def to_xml(options = {})
    options[:except] = [:crypted_password, :salt, :email, :open_id_url, :password_reset_code, :remember_token, :remember_token_expires_at]
    super(options)
  end
    
  def unseen_tickets
    Ticket.not_private.newest_first :limit => ["created_at > ?", self.previous_login]
  end
  
  def to_param
    "#{self.login}"
  end
  
  # Activates the user in the database.
  def activate
    @activated = true
    self.attributes = {:activated_at => Time.now.utc, :activation_code => nil}
    save(false)
  end

  def activated?
    !! activation_code.nil?
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end 
  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find :first, :conditions => ['login = ? and activated_at IS NOT NULL', login] # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end
  
  def forgot_password
    @forgotten_password = true
    self.make_password_reset_code
  end
  
  def reset_password
    # First update the password_reset_code before setting the 
    # reset_password flag to avoid duplicate email notifications.
    update_attributes(:password_reset_code => nil)
    @reset_password = true
  end

  def recently_reset_password?
    @reset_password
  end

  def recently_forgot_password?
    @forgotten_password
  end
  
  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
    
    def password_required?
      open_id_url.nil? && (crypted_password.blank? || !password.blank?)
    end

    
    def make_activation_code
      self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end 
    
    def make_password_reset_code
     self.password_reset_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end
end
