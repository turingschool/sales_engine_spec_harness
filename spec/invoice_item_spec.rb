require 'spec_helper'

describe "SalesEngine invoice items" do
  context "Searching" do
    describe ".random" do
      it "usually returns different things on subsequent calls" do
        invoice_item_one = engine.invoice_item_repository.random
        invoice_item_two = engine.invoice_item_repository.random

        10.times do
          break if invoice_item_one.id != invoice_item_two.id
          invoice_item_two = engine.invoice_item_repository.random
        end

        invoice_item_one.id.should_not == invoice_item_two.id
      end
    end

    describe ".find_by_item_id" do
      it "can find a record" do
        invoice_item = engine.invoice_item_repository.find_by_item_id 123
        invoice_item.item.name.should == "Item Doloribus Ducimus"
      end
    end

    describe ".find_all_by_quantity" do
      it "can find multiple records" do
        invoice_items = engine.invoice_item_repository.find_all_by_quantity 10
        expect(invoice_items.size).to eq 2140
      end
    end
  end

  context "Relationships" do
    let(:invoice_item) { engine.invoice_item_repository.find_by_id 16934 }

    describe "#item" do
      it "exists" do
        invoice_item.item.name.should == "Item Cupiditate Magni"
      end
    end

    describe "#invoice" do
      it "exists" do
        invoice_item.invoice.should be
      end
    end

  end
end

