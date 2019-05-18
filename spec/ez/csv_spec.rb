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

  describe "#find_rows_where" do

  end

  describe "#generate" do
    context "csv with headers" do
      let(:csv) { Ez::Csv.new(headers: ["header_1", "header_2"]) }

      context "csv with rows" do
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
      let(:csv) {
        file = Tempfile.create
      }
      context "csv with rows" do

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

  end

  describe "#remove_rows" do

  end

  describe "#sort_columns_by" do

  end

  describe "#update_row" do

  end

  describe "#update_rows" do

  end

  private

  def read_fixture(name)
    File.read(File.join("spec", "fixtures", name + ".csv"))
  end
end
