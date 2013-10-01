require 'spec_helper'

describe "SalesEngine items" do
  context "Searching" do
    describe ".random" do
      it "usually returns different things on subsequent calls" do
        item_one =engine.item_repository.random
        item_two = engine.item_repository.random

        10.times do
          break if item_one.id != item_two.id
          item_two = engine.item_repository.random
        end

        item_one.id.should_not == item_two.id
      end
    end

    describe ".find_by_unit_price" do
      it "can find one record" do
        item = engine.item_repository.find_by_unit_price BigDecimal.new("935.19")
        item.name.should == "Item Alias Nihil"
      end
    end

    describe ".find_all_by_name" do
      it "can find multiple records" do
        items = engine.item_repository.find_all_by_name "Item Eos Et"
        items.should have(3).items
      end
    end
  end

  context "Relationships" do
    let(:item) { engine.item_repository.find_by_name "Item Saepe Ipsum" }

    describe "#invoice_items" do
      it "has the correct number of them" do
        item.invoice_items.should have(8).items
      end

      it "really owns them all" do
        item.invoice_items.each do |ii|
          ii.item_id.should == item.id
        end
      end
    end

    describe "#merchant" do
      it "exists" do
        item.merchant.name.should == "Kilback Inc"
      end
    end

  end

  context "Business Intelligence" do

    describe ".most_revenue" do
      it "returns the top n items ranked by most total revenue" do
        most = engine.item_repository.most_revenue(5)

        most.first.name.should == "Item Dicta Autem"
        most.last.name.should  == "Item Amet Accusamus"
      end
    end

    describe ".most_items" do
      it "returns the top n items ranked by most sold" do
        most = engine.item_repository.most_items(37)

        most[1].name.should == "Item Nam Magnam"
        most.last.name.should   == "Item Ut Quaerat"
      end
    end

    describe "#best_day" do
      let(:item) { engine.item_repository.find_by_name "Item Accusamus Ut" }

      it "returns something castable to date" do
        best = [
          Date.new(2012, 3, 18),
          Date.new(2012, 3, 10),
          Date.new(2012, 3, 24)
        ]
        best.include?(item.best_day.to_date).should be_true
      end
    end

  end
end
