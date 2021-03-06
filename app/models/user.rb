class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, stretches: 14

  has_many :users_services
  has_many :services, :through => :users_services

  def self.create_with_password(attr={})
    generated_password = Devise.friendly_token.first(14)
    user = self.create(attr.merge(password: generated_password, password_confirmation: generated_password))

    UserMailer.generated_password(user, generated_password, I18n.locale.to_s).deliver_now

    user
  end

  def self.reset_password(attr={})
    generated_password = Devise.friendly_token.first(14)
    user = self.find_by(email: attr[:email])
    message = nil

    if !user.nil?
      if !user.reset_password_sent_at.today?
        user.update(password: generated_password, password_confirmation: generated_password)
        user.reset_password_sent_at = DateTime.now
        user.save
        UserMailer.reset_password(user, generated_password, I18n.locale.to_s).deliver_now
      else
        message = I18n.t('model.user.reset_password')
      end
    end

    if message != nil
      message
    elsif !user.nil?
      message = I18n.t('model.user.new_password')
      message
    else
      message = I18n.t('model.user.email_doesnt_exist')
      message
    end
  end
end
