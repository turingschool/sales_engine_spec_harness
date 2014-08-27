require 'spec_helper'

describe "SalesEngine invoice extensions", invoice: true do
  context "extensions" do
    describe ".pending" do
      it "returns Invoices without a successful transaction" do
        invoice = engine.invoice_repository.find_by_id(13)
        pending_invoices = engine.invoice_repository.pending

        pending_invoices.include?(invoice).should == true
      end
    end

    describe ".average_revenue" do
      it "returns the average of the totals of each invoice" do
        engine.invoice_repository.average_revenue.should == BigDecimal("12369.53")
      end
    end

    describe ".average_revenue(date)" do
      it "returns the average of the invoice revenues for that date" do
        engine.invoice_repository.average_revenue(Date.parse("March 17, 2012")).should == BigDecimal("11603.14")
      end
    end

    describe ".average_items" do
      it "returns the average of the number of items for each invoice" do
        engine.invoice_repository.average_items.should == BigDecimal("24.45")
      end
    end

    describe ".average_items(date)" do
      it "returns the average of the invoice items for that date" do
        engine.invoice_repository.average_items(Date.parse("March 21, 2012")).should == BigDecimal("24.29")
      end
    end
  end
end
