require 'spec_helper'

RSpec.describe "SalesEngine  transactions" do

  context "Searching" do
    describe ".random" do
      it "usually returns different things on subsequent calls" do
        transaction_one = engine.transaction_repository.random
        transaction_two = engine.transaction_repository.random

        10.times do
          break if transaction_one.id != transaction_two.id
          transaction_two = engine.transaction_repository.random
        end

        expect(transaction_one.id).to_not eq transaction_two.id
      end
    end

    describe ".find_by_credit_card_number" do
      it "can find a record" do
        transaction = engine.transaction_repository.find_by_credit_card_number "4634664005836219"
        expect(transaction.id).to eq 5536
      end
    end

    describe ".find_all_by_result" do
      it "can find multiple records" do
        transactions = engine.transaction_repository.find_all_by_result "success"
        expect(transactions.count).to be_within(2).of(4648)
      end
    end
  end

  context "Relationships" do
    let(:transaction) { engine.transaction_repository.find_by_id 1138 }

    describe "#invoice" do
      it "exists" do
        invoice_customer = engine.customer_repository.find_by_id 192
        expect(transaction.invoice.customer.first_name).to eq invoice_customer.first_name
      end
    end

  end
end

