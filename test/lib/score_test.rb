require "test_helper"

module QuestionKit
  class ScoreTest < ActiveSupport::TestCase
    def budget
      { "options" => [ { "value" => "low", "weight" => 1 }, { "value" => "high", "weight" => 5 } ] }
    end

    test "a chosen answer is worth the weight it carries" do
      assert_equal 5, Score.worth(budget, "high")
    end
  end
end
