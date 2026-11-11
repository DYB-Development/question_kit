require "test_helper"

module QuestionKit
  class QuestionImportTest < ActionDispatch::IntegrationTest
    setup do
      flow_host.owner_method = :current_customer
      @ours = Customer.create!(name: "Ours")
      @theirs = Customer.create!(name: "Theirs")
    end

    teardown { flow_host.owner_method = nil }

    MAPPING = { "0" => "type", "1" => "question", "2" => "category", "3" => "answer_1", "4" => "answer_2",
                "5" => "answer_3", "6" => "answer_4", "7" => "right_answer" }.freeze

    test "the upload page for a quiz lists the fields a file's columns are matched to" do
      get ixport.new_import_path(key: :quiz_questions, target: quiz.to_global_id), headers: as(@ours)

      assert_select "[data-expected-field]", text: "Right answer"
    end

    test "a builder cannot open the upload page for another owner's quiz" do
      get ixport.new_import_path(key: :quiz_questions, target: quiz(@theirs).to_global_id), headers: as(@ours)

      assert_response :not_found
    end

    private
      def flow_host
        EasyFlow.host_named(QuestionKit.flow_host)
      end

      def quiz(owner = @ours)
        EasyFlow::Definition.create!(host: QuestionKit.flow_host.to_s, slug: "quiz-#{owner.id}", owner: owner).tap do |flow|
          flow.record_definition(flowing("slug" => flow.slug, "entry" => "first",
            "nodes" => [ { "id" => "first", "type" => "question", "question" => "First?",
                           "answers" => [ { "value" => "Yes", "weight" => 1 }, { "value" => "No" } ] },
                         { "id" => "end", "type" => "terminal" } ],
            "edges" => [ { "from" => "first", "to" => "end" } ]))
          flow.publish
        end
      end

      def uploaded(file, into:)
        post ixport.imports_path, params: { key: :quiz_questions, target: into.to_global_id.to_s,
                                            file: fixture_file_upload(file, "text/csv") }, headers: as(@ours)
        Ixport::Import.last.tap do |import|
          patch ixport.import_mapping_path(import), params: { mapping: MAPPING }, headers: as(@ours)
        end
      end

      def as(customer)
        { "X-Customer" => customer.id.to_s }
      end
  end
end
