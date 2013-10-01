require './../sales_engine/lib/sales_engine'
require 'date'

RSpec.configure do |config|
  config.before(:suite) do
    $engine = SalesEngine.new("./data")
    $engine.startup
  end
end

def engine
  $engine
end

