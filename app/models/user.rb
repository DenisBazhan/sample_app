# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#
require "digest"
class User < ActiveRecord::Base
  attr_accessor :password

  #Доступные атрибуты в целях безопасности
  attr_accessible :name, :email, :password, :password_confirmation

  #Валидация
  validates :name, :presence => true,
                   :length   => { :maximum => 50 }

  validates :email, :presence => true

  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }
  before_save :encrypt_password

  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  #self.authenticate это User.authenticate так удобнее
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end

  private

    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypt_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end

