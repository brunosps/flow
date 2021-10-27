class SerializeUserStep < Flow::Step
  @[Flow::Property(required: true)]
  property user : User?

  def call : Flow::Result
    failure("invalid_user", "User is not valid") unless user

    user_serialize = UserSerialize.new(user.not_nil!)

    success({"user" => user_serialize.to_json})
  end
end
