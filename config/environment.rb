RAILS_GEM_VERSION = '2.1' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|

  config.action_controller.session = {
    :session_key => '_ticket_session',
    :secret      => 'f1b848a23c89a0f9b2aeb329547e9d873911da720c959d08be363c07948b5b1e69c355cedb584aa1a2995e6a7c6813ef4861662096d2b2f2167efb387e316034'
  }

  config.active_record.observers = :user_observer, :feedback_observer

  config.active_record.default_timezone = :utc
end


