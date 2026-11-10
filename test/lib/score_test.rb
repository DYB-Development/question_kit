require "test_helper"

module QuestionKit
  class ScoreTest < ActiveSupport::TestCase
    def budget
      { "options" => [ { "value" => "low", "weight" => 1 }, { "value" => "high", "weight" => 5 } ] }
    end

    test "a chosen answer is worth the weight it carries" do
      assert_equal 5, Score.worth(budget, "high")
    end

    test "a chosen answer carrying no weight is worth nothing" do
      team = { "options" => [ { "value" => "yes", "weight" => 3 }, { "value" => "no" } ] }

      assert_equal 0, Score.worth(team, "no")
    end

    test "a weight a form wrote as text is read as a number" do
      written = { "options" => [ { "value" => "high", "weight" => "5" } ] }

      assert_equal 5, Score.worth(written, "high")
    end
  end
end
