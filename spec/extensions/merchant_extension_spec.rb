require 'spec_helper'

RSpec.describe "SalesEngine merchant extensions", merchant: true do
  context "extensions" do
    describe ".dates_by_revenue" do
      it  "returns an array of Dates in descending order of revenue" do
        dates = engine.merchant_repository.dates_by_revenue

        expect(dates[0]  == DateTime.parse("2012-03-09") || dates[0]  == Date.parse("2012-03-09")).to be true
        expect(dates[21] == DateTime.parse("2012-03-06") || dates[21] == Date.parse("2012-03-06")).to be true
      end
    end

    describe ".dates_by_revenue(x)" do
      it  "returns the top x Dates in descending order of revenue" do
        dates = engine.merchant_repository.dates_by_revenue(5)

        expect(dates.size).to eq 5
        expect(dates[1]  == DateTime.parse("2012-03-08") || dates[1]  == Date.parse("2012-03-08")).to be true
        expect(dates[-1] == DateTime.parse("2012-03-15") || dates[-1] == Date.parse("2012-03-15")).to be true
      end
    end

    describe ".revenue(range_of_dates)" do
      it "returns the total revenue for all merchants across several dates" do
        date_1 = Date.parse("2012-03-14")
        date_2 = Date.parse("2012-03-16")
        revenue = engine.merchant_repository.revenue(date_1..date_2)

        expect(revenue).to eq BigDecimal("8226179.74")
      end
    end

    describe "#revenue(range_of_dates)" do
      it "returns the total revenue for that merchant across several dates" do
        date_1 = Date.parse("2012-03-01")
        date_2 = Date.parse("2012-03-07")
        merchant = engine.merchant_repository.find_by_id(7)
        revenue = merchant.revenue(date_1..date_2)

        expect(revenue).to eq BigDecimal("57103.77")
      end
    end
  end
end
