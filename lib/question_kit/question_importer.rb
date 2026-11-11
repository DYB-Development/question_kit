module QuestionKit
  class QuestionImporter < Ixport::Importer
    field :type, label: "Type"
    field :question, label: "Question"
    field :category, label: "Category"
    UploadedQuestion::ANSWER_FIELDS.each.with_index(1) { |key, number| field key, label: "Answer #{number}" }
    field :right_answer, label: "Right answer"

    def records
      UploadedQuestions.new(target)
    end

    def self.allows?(account, quiz)
      host = EasyFlow.host_named(QuestionKit.flow_host)
      quiz.is_a?(EasyFlow::Definition) && quiz.host == QuestionKit.flow_host.to_s && (host.owner_method.nil? || quiz.owner == account)
    end
  end
end
