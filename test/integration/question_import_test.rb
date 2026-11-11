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

    test "a builder cannot open the upload page for a quiz on another easy_flow host" do
      other = EasyFlow::Definition.create!(host: "console", slug: "elsewhere", owner: @ours)

      get ixport.new_import_path(key: :quiz_questions, target: other.to_global_id), headers: as(@ours)

      assert_response :not_found
    end

    test "a builder can open the upload page for another owner's quiz when the host keeps no owners" do
      flow_host.owner_method = nil

      get ixport.new_import_path(key: :quiz_questions, target: quiz(@theirs).to_global_id), headers: as(@ours)

      assert_response :ok
    end

    test "a file of questions adds a question step for each row with its answers and right answer" do
      flow = quiz
      post ixport.import_run_path(uploaded("questions.csv", into: flow)), headers: as(@ours)

      assert_equal [ [ "Which planet is largest?", [ [ "Mars", 0 ], [ "Jupiter", 1 ], [ "Venus", 0 ], [ "Earth", 0 ] ] ],
                     [ "The Sun is a star.", [ [ "True", 1 ], [ "False", 0 ] ] ] ],
        imported_steps(flow).map { |step| [ step.config["question"], step.config["answers"].map { |answer| answer.values_at("value", "weight") } ] }
    end

    test "a file with a row that cannot become a question names that row and what is wrong with it" do
      import = uploaded("questions_with_a_bad_row.csv", into: quiz)

      get ixport.import_preview_path(import), headers: as(@ours)

      assert_select "[data-refused-row]", text: /3\s+Right answer must be true or false/
    end

    test "a file with a row that cannot become a question adds none of its questions" do
      flow = quiz
      import = uploaded("questions_with_a_bad_row.csv", into: flow)

      post ixport.import_run_path(import), headers: as(@ours)

      assert_equal [ "start", "first", "end" ], EasyFlow::Document.new(flow.reload.document).nodes.map(&:id)
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

      def imported_steps(flow)
        EasyFlow::Document.new(flow.reload.document).nodes.select { |step| step.id.start_with?("question_") }
      end

      def as(customer)
        { "X-Customer" => customer.id.to_s }
      end
  end
end
