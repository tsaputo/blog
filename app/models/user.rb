class User < ApplicationRecord
    has_many :articles, dependent: :destroy
    has_many :comments, dependent: :destroy
    attr_accessor :reset_token
    before_save { self.email = email.downcase }
    validates :name,  presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }

    def authenticated?(remember_token)
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end

    # Устанавливает атрибуты для сброса пароля.
    def create_reset_digest
        self.reset_token = User.new_token
        update_attribute(:reset_digest,  User.digest(reset_token))
        update_attribute(:reset_sent_at, Time.zone.now)
    end

    # Отправляет электронное письмо для сброса пароля.
    def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
    end

     # Возвращает дайджест данной строки
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    # Возвращает случайный токен
    def User.new_token
        SecureRandom.urlsafe_base64
    end

    # Запоминает пользователя в базе данных для использования в постоянной сессии.
    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end

    # Возвращает true, если предоставленный токен совпадает с дайджестом.
    def authenticated?(remember_token)
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end

    # Возвращает true, если истек срок давности ссылки для сброса пароля .
    def password_reset_expired?
        reset_sent_at < 2.hours.ago
    end

end
