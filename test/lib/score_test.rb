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

    def flags
      { "type" => "multiple_select",
        "answers" => [ { "value" => "red", "weight" => 2 }, { "value" => "blue", "weight" => 1 }, { "value" => "green", "weight" => 0 } ] }
    end

    test "a multiple select answer picking every right answer and no other is worth one" do
      assert_equal 1, Score.worth(flags, [ "blue", "red" ])
    end

    test "a multiple select answer picking a wrong answer is worth nothing" do
      assert_equal 0, Score.worth(flags, [ "blue", "red", "green" ])
    end

    test "a multiple select answer missing a right answer is worth nothing" do
      assert_equal 0, Score.worth(flags, [ "red" ])
    end

    def capital
      { "type" => "fill_in_the_blank", "accepted_answers" => [ { "value" => "Paris" }, { "value" => "Paree" } ] }
    end

    test "a typed answer matching an accepted answer is worth one" do
      assert_equal 1, Score.worth(capital, "Paree")
    end

    test "a typed answer differing only in letter case and outer spaces is worth one" do
      assert_equal 1, Score.worth(capital, "  pARIS ")
    end
  end
end
