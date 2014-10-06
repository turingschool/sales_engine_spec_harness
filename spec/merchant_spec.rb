require 'spec_helper'

RSpec.describe "SalesEngine merchants" do
  context "Searching" do
    describe ".random" do
      it "usually returns different things on subsequent calls" do
        merchant_one = engine.merchant_repository.random
        merchant_two = engine.merchant_repository.random

        10.times do
          break if merchant_one.id != merchant_two.id
          merchant_two = engine.merchant_repository.random
        end

        expect(merchant_one.id).to_not eq merchant_two.id
      end
    end

    describe ".find_by_name" do
      it "can find a record" do
        merchant = engine.merchant_repository.find_by_name "Marvin Group"
        expect(merchant.name).to eq "Marvin Group"
      end
    end

    describe ".find_all_by_name" do
      it "can find multiple records" do
        merchants = engine.merchant_repository.find_all_by_name "Williamson Group"
        expect(merchants.size).to eq 2
      end
    end
  end

  context "Relationships" do
    let(:merchant) { engine.merchant_repository.find_by_name "Kirlin, Jakubowski and Smitham" }

    describe "#items" do
      it "has the correct number of them" do
        expect(merchant.items.size).to eq 33
      end

      it "includes a known item" do
        expect(merchant.items.map &:name).to include 'Item Consequatur Odit'
      end
    end

    describe "#invoices" do
      it "has the correct number of them" do
        expect(merchant.invoices.size).to eq 43
      end

      it "has a shipped invoice for a specific customer" do
        invoice = merchant.invoices.find {|i| i.customer.last_name == 'Block' }
        expect(invoice.status).to eq "shipped"
      end
    end
  end

  context "Business Intelligence" do

    describe ".revenue" do
      it "returns all revenue for a specific date" do
        date = Date.parse "Tue, 20 Mar 2012"

        expect(engine.merchant_repository.revenue date).to eq BigDecimal.new("2549722.91")
      end
    end

    describe ".most_revenue" do
      it "returns the top n revenue-earners" do
        most = engine.merchant_repository.most_revenue(3)
        expect(most.first.name).to eq "Dicki-Bednar"
        expect(most.last.name).to  eq "Okuneva, Prohaska and Rolfson"
      end
    end

    describe ".most_items" do
      it "returns the top n item-sellers" do
        most = engine.merchant_repository.most_items(5)
        expect(most.first.name).to eq "Kassulke, O'Hara and Quitzon"
        expect(most.last.name).to eq "Daugherty Group"
      end
    end

    describe "#revenue" do
      context "without a date" do
        let(:merchant) { engine.merchant_repository.find_by_name "Dicki-Bednar" }

        it "reports all revenue" do
          expect(merchant.revenue).to eq BigDecimal.new("1148393.74")
        end
      end
      context "given a date" do
        let(:merchant) { engine.merchant_repository.find_by_name "Willms and Sons" }

        it "restricts to that date" do
          date = Date.parse "Fri, 09 Mar 2012"

          expect(merchant.revenue date).to eq BigDecimal.new("8373.29")
        end
      end
    end

    describe "#favorite_customer" do
      let(:merchant) { engine.merchant_repository.find_by_name "Terry-Moore" }
      let(:customer_names) do
        [["Jayme", "Hammes"], ["Elmer", "Konopelski"], ["Eleanora", "Kling"],
         ["Friedrich", "Rowe"], ["Orion", "Hills"], ["Lambert", "Abernathy"]]
      end

      it "returns the customer with the most transactions" do
        customer = merchant.favorite_customer
        expect(customer_names).to be_any { |first_name, last_name|
          customer.first_name == first_name && customer.last_name  == last_name
        }
      end
    end

    describe "#customers_with_pending_invoices" do
      let(:merchant) { engine.merchant_repository.find_by_name "Parisian Group" }

      it "returns the total number of customers with pending invoices" do
        customers = merchant.customers_with_pending_invoices
        expect(customers.count).to eq 4
        expect(customers.map &:last_name).to include 'Ledner'
      end
    end
  end

end
