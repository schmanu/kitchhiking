require 'test_helper'

class HikerTest < ActiveSupport::TestCase
   test "create and delete hiker" do 
   		testhiker = Hiker.new(password: "sehr geheim", email: "mail@test.de")
   		assert_equal(false, testhiker.save)

   		testhiker.username = "TestHiker"
   		assert(testhiker.save)	

   		assert(testhiker.delete)
   	end

   	test "test name conflicts" do
   		testhiker1 = Hiker.new(password: "sehr geheim", email: "mail@test.de", username: "ManUSchManu")
   		testhiker2 = Hiker.new(password: "sehr geheim", email: "mail2@test.de", username: "ManuSchmanu")
   		assert(testhiker1.save)
   		assert_equal(false, testhiker2.save, 
   			"Es duerfen keine zwei User mit gleichem Namen vorhanden sein")


   		testhiker2.username = "ManuSchmanu2"

   		assert(testhiker2.save, "User creation failed with errors: "+testhiker2.errors.full_messages.to_s)

   		testhiker1.delete
   		testhiker2.delete
   	end
end
