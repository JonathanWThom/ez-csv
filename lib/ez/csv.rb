# frozen_string_literal: true
require "ez/row"
require "array"
require "csv"
require "byebug"
require "securerandom"

module Ez
  class Csv
    VERSION = "0.1.0"

    class Error < StandardError
      INVALID_HEADERS = "Invalid row headers"
      INVALID_METHOD = "Method not allowed for CSV without headers"
      NO_HEADERS = "Csv does not have any headers"
      ROW_NOT_FOUND = "Row not found"
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

    def change_row_order(new_order)
      # todo change the order of the rows
    end

    def find_rows_where(&block)
      raise Error, Error::INVALID_METHOD if headers.empty?

      rows.select { |row| yield(row) }.map { |r| rows.index(r) } if block_given?
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

      self
    end

    def remove_row(index)
      if !rows.delete_at(index)
        raise Error, Error::ROW_NOT_FOUND
      end
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
      # TODO: Should be same order as headers, in the case that a row is created
      # with params in an odd order.
      rows.map do |row|
        row.params = Hash[headers.map { |h| [h, row.params[h.to_sym]]}]
      end
    end
  end

end
