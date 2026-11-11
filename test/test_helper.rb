# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [ File.expand_path("../test/dummy/db/migrate", __dir__) ]
require "rails/test_help"

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_paths=)
  ActiveSupport::TestCase.fixture_paths = [ File.expand_path("fixtures", __dir__) ]
  ActionDispatch::IntegrationTest.fixture_paths = ActiveSupport::TestCase.fixture_paths
  ActiveSupport::TestCase.file_fixture_path = File.expand_path("fixtures", __dir__) + "/files"
  ActiveSupport::TestCase.fixtures :all
end

module BuildsFlows
  def flowing(document)
    beginning = document["entry"]

    document.except("entry").merge(
      "nodes" => [ { "id" => "start", "type" => "start" } ] + Array(document["nodes"]),
      "edges" => (beginning ? [ { "from" => "start", "to" => beginning } ] : []) + Array(document["edges"])
    )
  end
end

ActiveSupport::TestCase.include BuildsFlows
ActionDispatch::IntegrationTest.include BuildsFlows
