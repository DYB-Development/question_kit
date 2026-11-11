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

  test "a multiple select answer weight is explained as one point for ticking exactly the right answers" do
    assert_match(/above zero.*one point.*every right answer and no others/, explained("multiple_select", "answers", "weight"))
  end

  test "a host app's own explanation replaces question_kit's for that field" do
    flow_host.setting_explanations = { question: { "answers.weight" => "The host app's words." } }

    assert_equal "The host app's words.", explained("question", "answers", "weight")
  end

  test "a question answer's value is explained as what is saved and what shows when the label is blank or values are shown" do
    assert_match(/saved.*label is blank.*shows answer values/, explained("question", "answers", "value"))
  end

  test "a question answer's label is explained as the text a player sees in place of the value" do
    assert_match(/player sees.*in place of its value/, explained("question", "answers", "label"))
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
