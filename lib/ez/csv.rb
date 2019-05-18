# frozen_string_literal: true
require "ez/csv/version"
require "csv"
require "byebug"
require "securerandom"

module Ez
  class Csv
    class Error < StandardError
      INVALID_HEADERS = "Invalid row headers"
      NO_HEADERS = "Csv does not have any headers"
      SPECIFY_HEADERS = "Must specify headers for each row column"
    end

    attr_reader :rows
    attr_accessor :headers

    def initialize(headers: [])
      @rows = []
      @headers = headers
    end

    def add_row(params = {})
      if headers.any?
        if params.is_a?(Hash) && !params.keys.included_in?(headers.map(&:to_sym))
          raise Error, Error::INVALID_HEADERS
        elsif params.is_a?(Array)
          raise Error, Error::SPECIFY_HEADERS
        end
      else
        if params.is_a?(Hash)
          raise Error, Error::NO_HEADERS
        end
      end

      rows << Row.new(params)
    end

    def find_rows_where(&block)
      # returns rows with indices?
      # then can be removed or updated

      # value at header1 is false
      # indices = find_rows_where(&block)
    end

    def generate(path = "#{SecureRandom.uuid}.csv")
      CSV.open(*csv_args(path)) do |csv|
        ordered_rows.each do |row|
          csv << row.values
        end
      end
    end

    def read(path, headers: false)
      raw = CSV.read(path, headers: headers)
      if headers
        self.headers = raw.first.headers

        raw.each do |row|
          add_row(row.to_h)
        end
      end
    end

    def remove_row(index)
      rows.delete_at(index)
    end

    def remove_rows(*indices)
      indices.each do |index|
        rows.delete_at(index)
      end
    end

    def sort_columns_by(field, order: :asc)
      # todo
      # can change order
      # can do second tier ordering
      ## allow them to pass block for custom sorting?
    end

    def update_row(index, &block)
      # todo
    end

    # I don't think this syntax works. Might have to put block first, or just
    # make indices a regular array
    def update_rows(*indices, &block)
      indices.each do |index|
        update_row(index, block)
      end
    end

    private

    def csv_args(path)
      args = [path, "wb"]
      if headers.any?
        args.push(
          write_headers: true,
          headers: headers
        )
      end

      args
    end

    def ordered_rows
      # should be same order as headers
      rows
    end
  end

  class Row
    attr_reader :params

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

class Array
  def included_in?(array)
    array.to_set.superset?(self.to_set)
  end
end
