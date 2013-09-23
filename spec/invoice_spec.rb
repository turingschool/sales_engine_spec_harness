require 'spec_helper'

describe "SalesEngine invoices" do
  context "Searching" do
    describe ".random" do
      it "usually returns different things on subsequent calls" do
        invoice_one = engine.invoice_repository.random
        invoice_two = engine.invoice_repository.random

        10.times do
          break if invoice_one.id != invoice_two.id
          invoice_two = engine.invoice_repository.random
        end

        invoice_one.id.should_not == invoice_two.id
      end
    end

    describe ".find_by_status" do
      it "can find a record" do
        invoice = engine.invoice_repository.find_by_status "cool"
        invoice.should be_nil
      end
    end

    describe ".find_all_by_status" do
      it "can find multiple records" do
        invoices = engine.invoice_repository.find_all_by_status "shipped"
        invoices.should have(4843).invoices
      end
    end
  end

  context "Relationships" do
    let(:invoice) { engine.invoice_repository.find_by_id 1002 }

    describe "#transactions" do
      it "has the correct number of them" do
        invoice.transactions.should have(1).transaction
      end
    end

    describe "#items" do
      it "has the correct number of them" do
        invoice.items.should have(3).items
      end

      it "has one with a specific name" do
        item = invoice.items.find {|i| i.name == 'Item Accusamus Officia' }
        item.should_not be_nil
      end
    end

    describe "#customer" do
      it "exists" do
        invoice.customer.first_name.should == "Eric"
        invoice.customer.last_name.should  == "Bergnaum"
      end
    end

    describe "#invoice_items" do
      it "has the correct number of them" do
        invoice.invoice_items.should have(3).items
      end

      it "has one for a specific item" do
        item = invoice.invoice_items.find {|ii| ii.item.name == 'Item Accusamus Officia' }
        item.should_not be_nil
      end
    end
  end

  context "Business Intelligence" do

    describe ".create" do
      let(:customer) { engine.customer_repository.find_by_id(7) }
      let(:merchant) { engine.merchant_repository.find_by_id(22) }
      let(:items) do
        (1..3).map { engine.item_repository.random }
      end
      it "creates a new invoice" do

        invoice = engine.invoice_repository.create(customer: customer, merchant: merchant, items: items)

        items.map(&:name).each do |name|
          invoice.items.map(&:name).should include(name)
        end

        invoice.merchant_id.should == merchant.id
        invoice.customer.id.should == customer.id
      end
    end

    describe "#charge" do
      it "creates a transaction" do
        invoice = engine.invoice_repository.find_by_id(100)
        prior_transaction_count = invoice.transactions.count

        invoice.charge(credit_card_number: '1111222233334444',  credit_card_expiration_date: "10/14", result: "success")

        invoice = engine.invoice_repository.find_by_id(invoice.id)
        invoice.transactions.count.should == prior_transaction_count + 1
      end
    end

  end
end
