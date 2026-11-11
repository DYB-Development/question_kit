require "test_helper"

module QuestionKit
  class AnswerKeyTest < ActiveSupport::TestCase
    test "the key to a single-choice question is the answer that carries points" do
      step = { "type" => "question", "answers" => [ { "value" => "a", "weight" => 0 }, { "value" => "b", "weight" => 1 } ] }

      assert_equal "b", AnswerKey.chosen(step)
    end

    test "the key to a multiple-select question is every answer that carries points" do
      step = { "type" => "multiple_select", "answers" => [ { "value" => "a", "weight" => 1 }, { "value" => "b", "weight" => 0 }, { "value" => "c", "weight" => 1 } ] }

      assert_equal %w[a c], AnswerKey.chosen(step)
    end

    def capital
      { "type" => "fill_in_the_blank", "accepted_answers" => [ { "value" => "Paris" }, { "value" => "Paree" } ] }
    end

    test "the key to a fill-in-the-blank question is its first accepted answer" do
      assert_equal "Paris", AnswerKey.chosen(capital)
    end

    test "a fill-in-the-blank question accepts every answer listed on it" do
      assert_equal %w[Paris Paree], AnswerKey.accepted(capital)
    end

    test "a blank accepted answer is not listed" do
      step = { "type" => "fill_in_the_blank", "accepted_answers" => [ { "value" => "" }, { "value" => "Paris" } ] }

      assert_equal %w[Paris], AnswerKey.accepted(step)
    end
  end
end
