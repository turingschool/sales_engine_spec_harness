require 'spec_helper'

RSpec.describe "SalesEngine items" do
  context "Searching" do
    describe ".random" do
      it "usually returns different things on subsequent calls" do
        item_one =engine.item_repository.random
        item_two = engine.item_repository.random

        10.times do
          break if item_one.id != item_two.id
          item_two = engine.item_repository.random
        end

        expect(item_one.id).to_not eq item_two.id
      end
    end

    describe ".find_by_unit_price" do
      it "can find one record" do
        item = engine.item_repository.find_by_unit_price BigDecimal.new("935.19")
        expect(item.name).to eq "Item Alias Nihil"
      end
    end

    describe ".find_all_by_name" do
      it "can find multiple records" do
        items = engine.item_repository.find_all_by_name "Item Eos Et"
        expect(items.size).to eq 3
      end
    end
  end

  context "Relationships" do
    let(:item) { engine.item_repository.find_by_name "Item Saepe Ipsum" }

    describe "#invoice_items" do
      it "has the correct number of them" do
        expect(item.invoice_items.size).to eq 8
      end

      it "really owns them all" do
        item.invoice_items.each do |ii|
          expect(ii.item_id).to eq item.id
        end
      end
    end

    describe "#merchant" do
      it "exists" do
        expect(item.merchant.name).to eq "Kilback Inc"
      end
    end

  end

  context "Business Intelligence" do

    describe ".most_revenue" do
      it "returns the top n items ranked by most total revenue" do
        most = engine.item_repository.most_revenue(5)

        expect(most.first.name).to eq "Item Dicta Autem"
         expect(most.last.name).to eq "Item Amet Accusamus"
      end
    end

    describe ".most_items" do
      it "returns the top n items ranked by most sold" do
        most = engine.item_repository.most_items(37)

        expect(most[1].name).to   eq "Item Nam Magnam"
        expect(most.last.name).to eq "Item Ut Quaerat"
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
        expect(best).to include item.best_day
      end
    end

  end
end
