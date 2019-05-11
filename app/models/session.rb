class Session
  extend ActiveModel::Naming
  include ActiveModel::AttributeAssignment
  include ActiveModel::Conversion

  attr_accessor :handle, :password

  def initialize(attributes={})
    assign_attributes(attributes) if attributes
    super()
  end

end
