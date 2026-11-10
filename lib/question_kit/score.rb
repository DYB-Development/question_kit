module QuestionKit
  module Score
    def self.worth(step, value)
      return picked_worth(step, value) if step["type"] == "multiple_select"
      return typed_worth(step, value) if step["type"] == "fill_in_the_blank"

      chosen = EasyFlow::Steps::Question.answers_of(step).find { |answer| answer.is_a?(Hash) && answer["value"] == value }

      chosen&.fetch("weight", nil).to_i
    end

    def self.typed_worth(step, text)
      Array(step["accepted_answers"]).any? { |accepted| accepted["value"] == text } ? 1 : 0
    end

    def self.picked_worth(step, values)
      Array(values).sort == right_answers(step).sort ? 1 : 0
    end

    def self.right_answers(step)
      EasyFlow::Steps::Question.answers_of(step).filter_map { |answer| answer["value"] if answer["weight"].to_i.positive? }
    end
  end
end
