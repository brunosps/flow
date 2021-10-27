class SendMailStep < Flow::Step
  @[Flow::Property(required: true)]
  property email : Email?

  def call : Flow::Result
    return failure("Email is not valid!!!") unless email.not_nil!.valid?
    success("Email has been send!")
  end
end
