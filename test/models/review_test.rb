require 'test_helper'

class ReviewTest < ActiveSupport::TestCase
  test "create reviews" do
  	hiker = Hiker.create(password: "sehr geheim", email: "mail@test.de", username: "to be reviewed")
  	hiker2 = Hiker.create(password: "sehr geheim", email: "mail2@test.de", username: "reviewer")

  	dinner = Dinner.create(hiker: hiker, title: "Aweseome delicious stuff", 
      dinner_start_date: DateTime.now + 1.hours, 
      dinner_end_date: DateTime.now + 4.hours)

  	review = Review.new()



  	assert_equal(false, review.save, "No Empty Review should be possible")
  	
  	review.dinner = dinner
  	review.writer = hiker

  	assert_equal(false, review.save, "No Self-Review should be possible")


  	review.writer = hiker2
    review.save

  	assert(review.errors[:dinner][0].starts_with?(I18n.t 'activerecord.errors.models.review.attributes.dinner.invalid', advice: nil), 
      "Unattended Dinner should be invalid:\nError messages do not fit: \n" + review.errors[:dinner][0]+ "\n" +
      I18n.t('activerecord.errors.models.review.attributes.dinner.invalid', advice: nil))

    request = Request.create(subject: "Subject", body: "Body", dinner: dinner, hiker: hiker2)

    review.save

    assert(review.errors[:dinner][0].starts_with?(I18n.t 'activerecord.errors.models.review.attributes.dinner.invalid', advice: nil), 
      "Unattended Dinner should be invalid:Error messages do not fit: \n" + review.errors[:dinner][0]+ "\n" +
      I18n.t('activerecord.errors.models.review.attributes.dinner.invalid', advice: nil))


    request.accepted!
    request.save

    review.save 
    assert(review.errors[:dinner][0].starts_with?(I18n.t 'activerecord.errors.models.review.attributes.dinner.invalid', advice: nil), 
      "Dinner must be in the past:Error messages do not fit: \n" + review.errors[:dinner][0]+ "\n" +
      I18n.t('activerecord.errors.models.review.attributes.dinner.invalid', advice: nil))
    
    dinner.dinner_start_date = DateTime.new(2013, 3, 17, 20)
    dinner.dinner_end_date = DateTime.new(2013, 3, 17, 23)
    dinner.save

    
    assert(review.save, "Saving Review should have worked but failed with errors: \n"+
      review.errors.full_messages.to_s)

  	assert(dinner.reload.reviews.include?(review), "Dinner should have the Review saved")

  	assert(hiker2.reload.written_reviews.include?(review), "Writer should have the Review saved")

  	assert(hiker.reload.received_reviews.include?(review), "Receiver should have the Review saved")

  end
end
