class User < ActiveRecord::Base
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, class_name: 'Question', dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]
         # , :confirmable


  validates :display_name, presence: true

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    return unless auth.info.try(:email)

    email = auth.info[:email]
    name = auth.info[:name]
    user = User.where(email: email).first

    if user
      user.create_authorization(auth)
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, display_name: name, password: password, password_confirmation: password)
      user.create_authorization(auth) if user
    end

    user
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end
  #
  # def self.send_daily_digest
  #   find_each.each do |user|
  #     DailyMailer.delay.digest(user)
  #   end
  # end
end
