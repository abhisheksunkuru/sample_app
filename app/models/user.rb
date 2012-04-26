class User < ActiveRecord::Base

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  attr_accessible :email, :name, :password, :password_confirmation, :terms
  has_secure_password                   

  before_save{ |user| user.email = email.downcase }
  before_create :create_remember_token
  validates :name, :presence => true, :length=>{ :maximum=>50 }
  
  validates :email, :presence => true, :format => {:with=> VALID_EMAIL_REGEX},
            :uniqueness => {:case_sensitive => false}
  validates :password, :length => { :minimum => 6 }
  validates :password_confirmation , :presence=> true

  private

    def create_remember_token
    	self.remember_token = SecureRandom.urlsafe_base64
    end	

end
