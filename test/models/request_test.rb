require 'test_helper'

class RequestTest < ActiveSupport::TestCase
  test "create and delete requests" do
  	request = Request.new()
  	assert_equal(false, request.save, "Es darf kein leerer Request angelegt werden")

  	hiker = Hiker.create(password: "sehr geheim", email: "mail@test.de",username: "Hiker1")
  	dinner = Dinner.create(title: "Perfect Dinner", hiker: hiker)
  	
  	request.dinner=dinner
  	request.hiker=hiker
  	request.subject="TestRequest123"
  	request.body="Ich bin neu in der Community und wuerde gerne mitessen!"
  	assert_equal(false, request.save, "Man darf sich nicht selbst keinen Request schicken")
    errorMessage=request.errors[:receiver][0]
    assert(errorMessage.starts_with?(I18n.t 'activerecord.errors.models.request.attributes.receiver.invalid', advice: nil), " \"#{errorMessage}\" does not match \"#{I18n.t 'activerecord.errors.models.request.attributes.receiver.invalid', advice: nil}\""+
    "\n")
  	hiker_request_sender = Hiker.create(password: "sehr geheim", email: "mail2@test.de",username: "Hiker2")
  	request.hiker=hiker_request_sender

  	assert(request.save, "Gültiger Request muss gespeichert werden können")

  	assert(hiker.reload.incoming_requests.include?(request), 
  		"Der Eingehende Request muss auch vom Hiker-Object aus erreichbar sein.")

  	assert(hiker_request_sender.reload.outgoing_requests.include?(request),
  		"Der Ausgehende Request muss auch vom Hiker-Object erreichbar sein.")
  end

  
end
