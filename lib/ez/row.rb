module Ez
  class Row
    attr_accessor :params

    def initialize(params)
      @params = params
    end

    def value_at(column)
      params[column.to_sym]
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
