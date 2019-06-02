RSpec.describe Ez::Csv do
  TEST_FILE = "test.csv"

  after(:each) do
    File.delete(TEST_FILE) if File.file?(TEST_FILE)
  end

  it "has a version number" do
    expect(Ez::Csv::VERSION).not_to be nil
  end

  describe "#add_row" do
    context "csv has no headers" do
      let(:csv) { Ez::Csv.new }

      context "row has no headers" do
        let(:params) { ["column_1_value", "column_2_value"] }

        it "adds row" do
          csv.add_row(params)

          expect(csv.rows.count).to eq 1
          expect(csv.rows.first).to be_an_instance_of(Ez::Row)
        end
      end

      context "row has headers" do
        let(:params) { { "header_1": true, "header_2": false } }

        it "raises error" do
          expect do
            csv.add_row(params)
          end.to raise_error(Ez::Csv::Error, Ez::Csv::Error::NO_HEADERS)
        end
      end
    end

    context "csv has headers" do
      let(:csv) { Ez::Csv.new(headers: ["header_1", "header_2"]) }

      context "row has no headers" do
        let(:params) { ["column_1_value", "column_2_value"] }

        it "raises error" do
          expect do
            csv.add_row(params)
          end.to raise_error(Ez::Csv::Error, Ez::Csv::Error::SPECIFY_HEADERS)
        end
      end

      context "row has complete correct headers" do
        let(:params) { { "header_1": "column_1_value", "header_2": "column_2_value"} }

        it "adds row" do
          csv.add_row(params)

          expect(csv.rows.count).to eq 1
          expect(csv.rows.first).to be_an_instance_of(Ez::Row)
        end
      end

      context "row has some correct headers" do
        let(:params) { { "header_2": "column_2_value"} }

        it "adds row" do
          csv.add_row(params)

          expect(csv.rows.count).to eq 1
          expect(csv.rows.first).to be_an_instance_of(Ez::Row)
        end
      end

      context "row has incorrect headers" do
        let(:params) { { "header_5": "column_5_value" } }

        it "raises error" do
          expect do
            csv.add_row(params)
          end.to raise_error(Ez::Csv::Error, Ez::Csv::Error::INVALID_HEADERS)
        end
      end
    end
  end

  describe "#change_row_order" do

  end

  describe "#find_rows_where" do
    context "csv has no headers" do
      let(:csv) { Ez::Csv.new }

      it "raises error" do
        expect do
          csv.find_rows_where do |row|
            row.value_at("header_1") == "no"
          end
        end.to raise_error(Ez::Csv::Error, Ez::Csv::Error::INVALID_METHOD)
      end
    end

    context "csv has headers" do
      let(:csv) {
        params1 = { "header_1": "yes", "header_2": "no" }
        params2 = { "header_1": "no", "header_2": "yes" }
        csv = Ez::Csv.new(headers: ["header_1", "header_2"])
        csv.add_row(params1)
        csv.add_row(params2)
        csv
      }

      it "returns correct row indices" do
        result = csv.find_rows_where do |row|
          row.value_at("header_1") == "no"
        end

        expect(result).to eq [1]
      end
    end
  end

  describe "#generate" do
    context "csv with headers" do
      let(:csv) { Ez::Csv.new(headers: ["header_1", "header_2"]) }

      context "csv with rows" do
        context "rows columns are in correct order" do
          before(:each) do
            2.times do
              csv.add_row({"header_1": "column_1_value", "header_2": "column_2_value"})
            end
          end

          it "generates correct csv" do
            csv.generate(TEST_FILE)
            contents = File.read(TEST_FILE)

            expect(contents).to eq read_fixture("csv_with_headers_and_rows")
          end
        end

        context "row columns are not in correct order" do
          before(:each) do
            2.times do
              csv.add_row({"header_2": "column_2_value", "header_1": "column_1_value"})
            end
          end

          it "generates correct csv" do
            csv.generate(TEST_FILE)
            contents = File.read(TEST_FILE)

            expect(contents).to eq read_fixture("csv_with_headers_and_rows")
          end
        end
      end

      context "csv with no rows" do
        it "generates correct csv" do
          csv.generate(TEST_FILE)
          contents = File.read(TEST_FILE)

          expect(contents).to eq read_fixture("csv_with_headers_no_rows")
        end
      end
    end

    context "csv with no headers" do
      let(:csv) { Ez::Csv.new }

      context "csv with rows" do
        before(:each) do
          2.times do
            csv.add_row(["column_1_value", "column_2_value"])
          end

          it "generates correct csv" do
            csv.generate(TEST_FILE)
            contents = File.read(TEST_FILE)

            expect(contents).to eq read_fixture("csv_with_no_headers_with_rows")
          end
        end
      end

      context "csv with no rows" do
        it "generates correct csv" do
          csv.generate(TEST_FILE)
          contents = File.read(TEST_FILE)

          expect(contents).to eq("")
        end
      end
    end
  end

  describe "#read" do
    context "csv with headers" do
      context "csv with rows" do
        let(:path) { path_to_fixture("csv_with_headers_and_rows") }
        let(:csv) { Ez::Csv.new.read(path, headers: true) }

        it "has correct headers" do

        end

        it "has correct rows" do

        end
      end

      context "csv with no rows" do

      end
    end

    context "csv with no headers" do
      context "csv with rows" do

      end

      context "csv with no rows" do

      end
    end
  end

  describe "#remove_row" do
    let(:csv) {
      csv = Ez::Csv.new
      csv.rows << Ez::Row.new("column_1_value")
      csv
    }

    context "row index is present" do
      it "removes row" do
        csv.remove_row(0)

        expect(csv.rows.length).to eq 0
      end
    end

    context "row index is not present" do
      let(:csv) { Ez::Csv.new }

      it "raises error" do
        expect do
          csv.remove_row(1)
        end.to raise_error Ez::Csv::Error::ROW_NOT_FOUND
      end
    end
  end

  describe "#remove_rows" do
    let(:csv) {
      csv = Ez::Csv.new
      2.times { csv.rows << Ez::Row.new("column_1_value") }
      csv
    }

    it "calls remove_row for each specified index" do
      expect(csv).to receive(:remove_row).with(0)
      expect(csv).to receive(:remove_row).with(1)

      csv.remove_rows(0, 1)
    end
  end

  describe "#sort_columns_by" do
    context "text columns" do
      # try with nil
      let(:a_row) { Ez::Row.new("column_1": "A") }
      let(:b_row) { Ez::Row.new("column_1": "B") }

      context "ascending order" do
        let(:csv) {
          csv = Ez::Csv.new(headers: ["column_1"])
          csv.rows << b_row
          csv.rows << a_row
          csv
        }

        it "returns rows in correct order" do
          csv.sort_columns_by("column_1")

          expect(csv.rows).to eq [a_row, b_row]
        end
      end

      context "descending order" do
        let(:csv) {
          csv = Ez::Csv.new(headers: ["column_1"])
          csv.rows << a_row
          csv.rows << b_row
          csv
        }

        it "returns rows in correct order" do
          csv.sort_columns_by("column_1", order: :desc)

          expect(csv.rows).to eq [b_row, a_row]
        end
      end
    end

    context "number columns" do
      let(:one_row) { Ez::Row.new("column_1": 1) }
      let(:two_row) { Ez::Row.new("column_1": 2) }

      context "ascending order" do
        let(:csv) {
          csv = Ez::Csv.new(headers: ["column_1"])
          csv.rows << two_row
          csv.rows << one_row
          csv
        }

        it "returns rows in correct order" do
          csv.sort_columns_by("column_1")

          expect(csv.rows).to eq [one_row, two_row]
        end
      end

      context "descending order" do
        let(:csv) {
          csv = Ez::Csv.new(headers: ["column_1"])
          csv.rows << one_row
          csv.rows << two_row
          csv
        }

        it "returns rows in correct order" do
          csv.sort_columns_by("column_1", order: :desc)

          expect(csv.rows).to eq [two_row, one_row]
        end
      end
    end

    context "unsupported column types" do
      let(:value_row) { Ez::Row.new("column_1": { key: "value" }) }
      let(:zalue_row) { Ez::Row.new("column_1": { key: "zalue" }) }
      let(:csv) {
        csv = Ez::Csv.new(headers: ["column_1"])
        csv.rows << zalue_row
        csv.rows << value_row
        csv
      }

      it "raises error" do
        expect do
          csv.sort_columns_by("column_1")
        end.to raise_error(Ez::Csv::Error::UNSUPPORTED_COLUMN_VALUES)
      end
    end

    context "header is not present" do
      let(:csv) {
        csv = Ez::Csv.new
        csv.rows << Ez::Row.new("value")
        csv
      }

      it "raises error" do
        expect do
          csv.sort_columns_by("column_1")
        end.to raise_error(Ez::Csv::Error::COLUMN_NOT_FOUND)
      end
    end

    context "column with a mix of numbers and strings" do

    end

    context "column has nil row values" do
      let(:row) { Ez::Row.new({"column_1": "value"}) }
      let(:nil_row) { Ez::Row.new({"column_1": nil}) }

      context "ascending sort" do
        let(:csv) {
          csv = Ez::Csv.new(headers: ["column_1"])
          csv.rows << nil_row
          csv.rows << row
          csv
        }

        it "moves nils to end of list" do
          csv.sort_columns_by("column_1")

          expect(csv.rows).to eq [row, nil_row]
        end
      end

      context "descending sort" do
        let(:csv) {
          csv = Ez::Csv.new(headers: ["column_1"])
          csv.rows << row
          csv.rows << nil_row
          csv
        }

        it "moves nils to start of list" do
          csv.sort_columns_by("column_1", order: :desc)

          expect(csv.rows).to eq [nil_row, row]
        end
      end
    end
  end

  describe "#update_row" do

  end

  describe "#update_rows" do

  end

  private

  def path_to_fixture(name)
    File.join("spec", "fixtures", name + ".csv")
  end

  def read_fixture(name)
    File.read(path_to_fixture(name))
  end
end
