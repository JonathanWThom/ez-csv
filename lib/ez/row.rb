module Ez
  class Row
    attr_accessor :params

    def initialize(params)
      @params = params
    end

    def values
      if params.is_a? Hash
        params.values
      else
        params
      end
    end
  end
end
