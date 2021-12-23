module Flow
  module Success
    def success
      data = {} of String => Hash(String, String)
      success(data)
    end

    def success(data : U) forall U
      result_type = "ok"
      Flow::Result(typeof(data)).new(true, data, result_type)
    end

    def success(message : String)
      data = {
        self.class.to_s => message,
      }
      success(data)
    end

    def success(message : String, data : U) forall U
      success(data.merge({
        self.class.to_s => message,
      }))
    end
  end
end
