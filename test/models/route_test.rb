require 'test_helper'

class RouteTest < ActiveSupport::TestCase
  	test "should not save route without origin" do
  		route = Route.new
  		route.place_destiny = Place.find_by_description('Local2')
  		route.distance = 15
  		assert_not route.save, "Saved the route without a origin"
	end

  	test "should not save route without destiny" do
  		route = Route.new
  		route.place_origin = Place.find_by_description('Local2')
  		route.distance = 15
  		assert_not route.save, "Saved the route without a destiny"
	end

  	test "should not save route without distance" do
  		route = Route.new
  		route.place_origin = Place.find_by_description('Local3')
  		route.place_destiny = Place.find_by_description('Local4')
  		assert_not route.save, "Saved the route without a distance"
	end

  	test "should save route with all fields" do
  		route = Route.new
  		route.distance = 30
  		route.place_origin = Place.find_by_description('Local3')
  		route.place_destiny = Place.find_by_description('Local4')
  		assert route.save, "Saved the route"
	end
  	
  	test "should not save duplicated route" do
  		route = Route.new
  		route.distance = 30
  		route.place_origin = Place.find_by_description('Local1')
  		route.place_destiny = Place.find_by_description('Local2')
  		assert_not route.save, "Saved the route duplicated"
	end

  	test "should not update route without origin" do
  		route = Route.where(place_origin: Place.find_by_description('Local1').id, place_destiny_id: Place.find_by_description('Local2').id).first
  		route.place_origin = nil
  		route.place_destiny = Place.find_by_description('Local2')
  		route.distance = 15
  		assert_not route.save, "Saved the route without a origin"
	end

  	test "should not update route without destiny" do
  		route = Route.where(place_origin: Place.find_by_description('Local1').id, place_destiny_id: Place.find_by_description('Local2').id).first
  		route.place_destiny = nil
  		route.place_origin = Place.find_by_description('Local2')
  		route.distance = 15
  		assert_not route.save, "Saved the route without a destiny"
	end

  	test "should not update route without distance" do
  		route = Route.where(place_origin: Place.find_by_description('Local1').id, place_destiny_id: Place.find_by_description('Local2').id).first
  		route.distance = nil
  		route.place_origin = Place.find_by_description('Local3')
  		route.place_destiny = Place.find_by_description('Local4')
  		assert_not route.save, "Saved the route without a distance"
	end

  	test "should update route with all fields" do
  		route = Route.where(place_origin: Place.find_by_description('Local1').id, place_destiny_id: Place.find_by_description('Local2').id).first
  		route.distance = 30
  		route.place_origin = Place.find_by_description('Local3')
  		route.place_destiny = Place.find_by_description('Local4')
  		assert route.save, "Saved the route"
	end

end
