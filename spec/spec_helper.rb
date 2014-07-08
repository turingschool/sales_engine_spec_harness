# For notifying students of mistakes they might make that will trip them up
die_because = lambda do |explanation|
  puts "\e[31m#{explanation}\e[0m"
  exit 1
end

# Must run with bundle exec
unless defined? Bundler
  die_because.call "Run with `bundle exec` or you'll have issues!"
end

# Must run from root
unless File.expand_path(Dir.pwd) == File.expand_path('../..',  __FILE__)
  die_because.call "Run the program from the root of the Spec Harness"
end

require './../sales_engine/lib/sales_engine'
require 'date'


# Must override #inspect on repositories (more on this at https://github.com/rspec/rspec-core/issues/1631)
all_repositories = Object.constants.grep(/Repository$/).map { |name| Object.const_get name }
bad_repositories = all_repositories.select { |repo| repo.instance_method(:inspect).owner == Kernel }
if bad_repositories.any?
  die_because.call <<-MESSAGE.gsub(/^ {4}/, '')
    \e[33mTHESE REPOSITORIES HAVE ISSUES: #{bad_repositories.inspect}\e[31m

    You need to override inspect on your repositories.
    If you don't, the default inspect will try try to create a string that includes
    add all the rows from the CSVs into the inspect.

    We run it against tens of thousands of rows, which means it will sudenly hang.

    e.g.
    class SomeRepository
      def inspect
        "#<\#{self.class} \#{@merchants.size} rows>"
      end
    end
  MESSAGE
end


RSpec.configure do |config|
  config.before(:suite) do
    $engine = SalesEngine.new("./data")
    $engine.startup
  end
end

def engine
  $engine
end

