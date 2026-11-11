require "test_helper"

module QuestionKit
  class EasyFlowStepsTest < ActiveSupport::TestCase
    test "easy_flow's builder writes a question's answers with the value and weight the score reads" do
      assert_equal({ "value" => "string", "weight" => "integer" }, written_fields("question", "answers"))
    end

    private

    def written_fields(step_type, list)
      palette_entry(step_type).dig("records", list).to_h.slice("value", "weight")
    end

    def palette_entry(step_type)
      EasyFlow::Canvas.new(EasyFlow::Document.new({}), host: EasyFlow::Host.new("plain")).to_h["palette"].find { |entry| entry["type"] == step_type }
    end
  end
end
