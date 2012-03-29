# SalesEngineSpecHarness

This is the evaluation test harness for SalesEngine. It requires your implementation of SalesEngine as a gem, then runs the evaluation specs against it.

## Installing Locally

Git clone this project into a directory that lives at the same level as your `sales_engine` project directory. It should be arranged like:

    <my_code_directory>
    |
    |\
    | \sales_engine/
    |
    |\
    | \sales_engine_spec_harness/
    |

Change directories into the `sales_engine_spec_harness/` directory and then execute:

    $ bundle

This will load in your `SalesEngine` implementation from your local file system. The spec harness provides the CSV files at `./data` relative to the current directory from the perspective of the spec run.

### Note:

Please be sure to name your gem `sales_engine` inside of your `sales_engine.gemspec` file. This **does differ** from the initial instructions. Sorry!


### Usage

To test your implementation against the evaluation specs, run:

    $ bundle exec rake spec

If you have implemtented the merchant extension, run:

    $ bundle exec rake spec:extensions:merchant

Similarly, if you have implemented the invoice or customer extensions, run:

    $ bundle exec rake spec:extensions:invoice
    # or
    $ bundle exec rake spec:extensions:customer

Or run them all with `bundle exec rake spec:extensions`.

You should be all green.

## Setup for Travis-CI - THIS IS NOW OPTIONAL!

**NOTE**: This is now optional. It might be more illustrative for you to instead do this process for *your* `SalesEngine` repo.

* Fork this repository and clone it to your machine
* Edit the `Gemfile` so it references _your_ `SalesEngine` gem from git using the *Git Read-Only* address. Ex:

```
gem 'sales_engine', :git => "git://github.com/jcasimir/sales_engine.git"
```

* Add the `SalesEngine::EXTENSIONS` constant described below to configure your extensions
* Push the changes to Github and check the results on Travis!

### Getting Your Extensions Evaluated (particularly on Travis CI)

If you've implemented any or all of the extensions and want them tested by the evaluation script, you will need to define a constant in `SalesEngine` that list each extension. I recommend just dropping it into `lib/sales_engine.rb`. Here's an example:

    # in file lib/sales_engine.rb

    module SalesEngine
      EXTENSIONS = %w(customer invoice merchant)

      def self.startup
        # ...
      end
    end

Of course, only list the extensions you've completed. If you haven't completed any, please assign an empty array to the `EXTENSIONS` constant.
