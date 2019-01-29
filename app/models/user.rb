class User < ApplicationRecord

    has_secure_password

    before_save { self.email = email.downcase }

    has_many :boards, dependent: :destroy

end