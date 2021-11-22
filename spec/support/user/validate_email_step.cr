class ValidateEmailStep < Flow::Step
  @[Flow::Property(required: true)]
  property email : String = ""

  def call : Flow::Result
    email_object = Email.new(email)

    return failure("invalid_email", "Email is not valid!") if !email_object.valid?

    success({"email" => email_object})
  end
end
