require 'spec_helper'

RSpec.describe "SalesEngine  customer extensions", customer: true do
  context "extensions" do

    describe "#days_since_activity" do
      it "returns a count of the days since the customer's last transaction" do
        allow(DateTime).to receive(:now).and_return(DateTime.parse "March 29, 2012")
        allow(Date).to receive(:today).and_return(Date.parse "March 29, 2012")
        days_since = engine.customer_repository.find_by_id(1).days_since_activity

        expect(days_since >= 3 || days_since <= 4).to eq true
      end
    end

    describe "#pending_invoices" do
      let(:pending) { engine.customer_repository.find_by_id(2).pending_invoices }
      context "when there are no pending invoices" do
        it "returns an empty array" do
          expect(pending).to be_empty
        end
      end
      context "when there are pending invoices" do
        let(:first_invoice) { engine.customer_repository.find_by_id(2).invoices.first }
        it "returns an array of the pending invoices" do
          bad_transaction = engine.transaction_repository.random
          allow(bad_transaction).to receive(:result).and_return("failed")
          allow(first_invoice).to receive(:transactions).and_return([bad_transaction])

          expect(pending).to eq [first_invoice]
        end
      end
    end

    describe ".most_items" do
      it "returns the customer who has purchased the most items" do
        expect(engine.customer_repository.most_items.id).to eq 622
      end
    end

    describe ".most_revenue" do
      it "returns the customer who has generated the most total revenue" do
        expect(engine.customer_repository.most_revenue.id).to eq 601
      end
    end
  end
end
