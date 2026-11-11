require "easy_flow"
require "question_kit/version"
require "question_kit/railtie"
require "question_kit/score"
require "question_kit/answer_key"
require "question_kit/time_taken"
require "question_kit/titled_start"
require "question_kit/uploaded_question"
require "question_kit/uploaded_questions"
require "question_kit/answer_explanations"

module QuestionKit
  class << self
    attr_reader :flow_host

    def flow_host=(name)
      @flow_host = name
      explain_answer_fields
    end

    def explain_answer_fields
      EasyFlow.host_named(flow_host).extend(AnswerExplanations) if flow_host
    end
  end
end
