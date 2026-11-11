Ixport.configure do |config|
  config.authentication_method = :require_a_customer
  config.current_person_method = :current_customer
  config.current_account_method = :current_customer
end

Ixport.register_import :quiz_questions, title: "Quiz questions", importer: "QuestionKit::QuestionImporter", refuse_whole_file: true,
  allow: ->(_person, account, quiz) { QuestionKit::QuestionImporter.allows?(account, quiz) }
