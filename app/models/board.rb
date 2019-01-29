class Board < ApplicationRecord

    belongs_to :user
    has_many :board_permissions, dependent: :destroy
    has_many :lists, dependent: :destroy

end