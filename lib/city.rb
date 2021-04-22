class City < ActiveRecord::Base
    has_many :crimes
    has_many :fugitives, through: :crimes

end