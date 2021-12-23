module Flow
  module Utils
    class MergeParams(T)
      def initialize(@params : T)
      end

      def merge(other : U) forall U
        # new_params : typeof(other, @params) = @params.dup
        new_params = {} of String => String

        other.each do |k, v|
          new_params = new_params.merge({k => v})
        end

        @params.each do |k, v|
          new_params = new_params.merge({k => v})
        end

        new_params
      end
    end
  end
end
