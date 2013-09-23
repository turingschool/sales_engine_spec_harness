# SalesEngineSpecHarness

This is the evaluation test harness for SalesEngine.

For this to run, all the `require` statements in your SalesEngine project must be `require_relative`.

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

### Usage

To test your implementation against the evaluation specs, run:

    $ rake spec

## TODO: Rework the extension specs to the new requirements

If you have implemtented the merchant extension, run:

    $ bundle exec rake spec:extensions:merchant

Similarly, if you have implemented the invoice or customer extensions, run:

    $ bundle exec rake spec:extensions:invoice
    # or
    $ bundle exec rake spec:extensions:customer

Or run them all with `bundle exec rake spec:extensions`.

You should be all green.

## TODO: Setup for Travis-CI (OPTIONAL)

