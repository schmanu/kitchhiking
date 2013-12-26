class Notification
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :date, :subject, :description, :picture_url, :icon
 
  
  def initialize(attributes = {})
    self.date = attributes[:date]
    self.subject = attributes[:subject]
    self.picture_url = attributes[:picture_url]
    self.icon = attributes[:icon]
    self.description = attributes[:desc]
  end
  
  def persisted?
    false
  end

end