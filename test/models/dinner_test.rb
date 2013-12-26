require 'test_helper'

class DinnerTest < ActiveSupport::TestCase
  test "create and delete Dinner" do
    
    hiker = Hiker.new(password: "sehr geheim", email: "mail@test.de", username: "testuserForDinnerTest")
    dinner = Dinner.new(title: "My First Dinner. Please Join!")
    assert_equal(false, dinner.save, "Ein Dinner benötigt Hiker")

    dinner.hiker=hiker
    assert(dinner.save, "Dinner mit Hiker sollte direkt abgespeichert werden")

    hiker.delete
    dinner.delete
  end
end
