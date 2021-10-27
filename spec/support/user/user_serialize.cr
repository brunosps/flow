class UserSerialize
  def initialize(@user : User)
  end

  def to_json
    {
      "user" => {
        "id"    => @user.id.to_s,
        "name"  => @user.name,
        "email" => @user.email,
      },
    }.to_json
  end
end
