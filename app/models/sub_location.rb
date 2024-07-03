class SubLocation < ApplicationRecord

    validates :name, presence: true, uniqueness: true


end
