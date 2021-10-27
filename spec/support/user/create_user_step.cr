class CreateUserStep < Flow::Step
  @[Flow::Property(required: true)]
  property name : String = ""

  @[Flow::Property(required: true)]
  property email : Email?

  def call : Flow::Result
    user = User.new(name: name, email: email.not_nil!.value)

    success({"user" => user})
  end
end
