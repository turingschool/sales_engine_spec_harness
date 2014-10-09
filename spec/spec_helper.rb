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
spec_harness_root = File.expand_path('../..',  __FILE__)
unless File.expand_path(Dir.pwd) == spec_harness_root
  die_because.call "Run the program from the root of the Spec Harness (#{spec_harness_root.inspect})"
end

# load their code
sales_engine_root = File.expand_path('../../../sales_engine/lib', __FILE__)
$LOAD_PATH.unshift(sales_engine_root)
begin
  require 'sales_engine'
rescue LoadError => e
  die_because.call "Expect sales engine to be in #{sales_engine_root.inspect}, when loaded it died because #{e.inspect}"
end
require 'date'


# Must override #inspect on repositories (more on this at https://github.com/rspec/rspec-core/issues/1631)
all_repositories = Object.constants.grep(/Repository$/).map { |name| Object.const_get name }
bad_repositories = all_repositories.select { |repo| repo.instance_method(:inspect).owner == Kernel }
if bad_repositories.any?
  die_because.call <<-MESSAGE.gsub(/^ {4}/, '')
    \e[33mTHESE REPOSITORIES HAVE ISSUES: #{bad_repositories.inspect}\e[31m

    You need to override inspect on your repositories.
    If you don't, the default inspect will try try to create a string so large that ruby will stop dead.
    This is generally true of anything that might try to print out all the rows and associated rows.

    If your test suite suddenly stops for over 2 minutes (these tests are integration, they are slow)
    then probably something is raising an exception, which inspects the object and triggers this issue.

    e.g.
    class SomeRepository
      def inspect
        "#<\#{self.class} \#{@merchants.size} rows>"
      end
    end
  MESSAGE
end


module SalesEngineSpecHelpers
  class << self
    attr_accessor :engine
  end

  def engine
    self.class.engine
  end
end

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.before(:suite) do
    SalesEngineSpecHelpers.engine = SalesEngine.new(File.join spec_harness_root, 'csvs')
    SalesEngineSpecHelpers.engine.startup
  end

  config.include Module.new {
    def engine
      SalesEngineSpecHelpers.engine
    end
  }
end
