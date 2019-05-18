RSpec.describe Ez::Csv do
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
          end.to raise_error(Ez::Csv::Error, "Csv does not have any headers")
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
          end.to raise_error(Ez::Csv::Error, "Please specify headers for each row column")
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
          end.to raise_error(Ez::Csv::Error, "Invalid row headers")
        end
      end
    end
  end

  describe "#remove_row" do

  end

  describe "#remove_rows" do

  end

  describe "#read" do

  end

  describe "#generate" do

  end

  describe "#sort_columns_by" do

  end

  describe "#find_rows_where" do

  end

  describe "#update_row" do

  end

  describe "#update_rows" do

  end
end
