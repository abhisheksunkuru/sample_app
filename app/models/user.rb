class User < ActiveRecord::Base

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  attr_accessible :email, :name, :password, :password_confirmation, :terms
  has_secure_password                   

  before_save{ |user| user.email = email.downcase }
  validates :name, :presence => true, :length=>{ :maximum=>50 }
  
  validates :email, :presence => true, :format => {:with=> VALID_EMAIL_REGEX},
            :uniqueness => {:case_sensitive => false}
  validates :password, :length => { :minimum => 6 }
  validates :password_confirmation , :presence=> true

end
