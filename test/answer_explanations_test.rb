require "test_helper"

class AnswerExplanationsTest < ActiveSupport::TestCase
  ANSWERED_STEP_TYPES = %w[question multiple_select fill_in_the_blank].freeze

  setup { @original_host = EasyFlow.host_named(QuestionKit.flow_host) }

  teardown do
    @original_host.setting_explanations = nil
    EasyFlow.hosts[QuestionKit.flow_host.to_s] = @original_host
  end

  test "a question's answer weight is explained as the points scored, with any weight above zero making it right" do
    assert_match(/points.*above zero.*right answer/, explained("question", "answers", "weight"))
  end

  private
    def explained(step_type, list, field, host: flow_host)
      palette_entry(step_type, host)["record_explanations"][list][field]
    end

    def other_entries(host)
      palette(host).reject { |entry| ANSWERED_STEP_TYPES.include?(entry["type"]) }
    end

    def palette_entry(step_type, host)
      palette(host).find { |entry| entry["type"] == step_type }
    end

    def palette(host)
      EasyFlow::Canvas.new(EasyFlow::Document.new({}), host: host).to_h["palette"]
    end

    def flow_host
      EasyFlow.host_named(QuestionKit.flow_host)
    end
end
