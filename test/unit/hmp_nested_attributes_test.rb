require File.dirname(__FILE__) + '/../test_helper'

require 'nested_attributes/car'
require 'nested_attributes/guitar'
require 'nested_attributes/owners_possession'
require 'nested_attributes/owner'

class HMPNestedAttributesTest < ActiveSupport::TestCase
  fixtures :owners, :possessions
  
  def test_nested_attributes_works
    owner = Owner.find(1)
    car = Car.find(1)
    guitar = Guitar.find(2)
    assert owner.possessions << car
    assert owner.possessions << guitar
    
    possessions_params = {}
    owner.possessions.each_with_index do |possession, index|
      possession.modify
      possessions_params[index] = possession.attributes
      possession.reload
    end
    
    owner_params = {
      "id" => 1, "name" => "James",
      "possessions_attributes" => possessions_params
    }
    
    owner.update_attributes(owner_params) # here's the failure
    
    # This is really testing accepts_nested_attributes_for, I guess.
    car.reload
    guitar.reload
    assert_equal "1977 3-door Volkswagon Beetle", car.description
    assert_equal "1970 7-string Gibson SG Special", guitar.description
  end
end
