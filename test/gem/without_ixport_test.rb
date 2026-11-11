require "test_helper"
require "open3"

class WithoutIxportTest < ActiveSupport::TestCase
  APP_WITHOUT_IXPORT = <<~RUBY
    require "bundler/setup"
    require "tmpdir"
    require "rails"
    require "active_record/railtie"
    require "action_controller/railtie"
    require "question_kit"

    class AppWithoutIxport < Rails::Application
      config.root = Dir.mktmpdir
      config.eager_load = false
      config.logger = Logger.new(nil)
      config.secret_key_base = "a" * 64
    end

    Rails.application.initialize!
    print [ defined?(Ixport).inspect, defined?(QuestionKit::QuestionImporter).inspect ].join(" ")
  RUBY

  test "an app without ixport loads question_kit with no question importer" do
    output, _status = Open3.capture2e({ "BUNDLE_GEMFILE" => File.expand_path("../../Gemfile", __dir__) }, RbConfig.ruby, "-e", APP_WITHOUT_IXPORT)

    assert_equal "nil nil", output.lines.last
  end
end
