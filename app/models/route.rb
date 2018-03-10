class Route < ApplicationRecord
	belongs_to :place_origin, :class_name => 'Place', :foreign_key => 'place_origin_id'
	belongs_to :place_destiny, :class_name => 'Place', :foreign_key => 'place_destiny_id'
	has_many :places
end
