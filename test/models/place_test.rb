require 'test_helper'

class PlaceTest < ActiveSupport::TestCase


  	test "should not save place without description" do
  		place = Place.new
  		assert_not place.save, "Saved the place without a description"
	end

  	test "should save place with description" do
  		place = Place.new(description: 'teste')
  		assert place.save, "Place Saved"
	end	

  	test "should not update place without description" do
  		place = Place.find_by_description('Local1')
  		place.description = ''
  		assert_not place.save, "Saved the place without a description"
	end

  	test "should update place with description" do
  		place = Place.find_by_description('Local1')
  		place.description = 'TesteX'
  		assert place.save, "Place Saved"
	end	
end
