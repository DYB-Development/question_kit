---
name: question_kit-develop
description: Use PROACTIVELY for scoring an easy_flow quiz — working out what one answer to a question, multiple-select or fill-in-the-blank step is worth, adding up a run's total score, listing a question's right answers, showing a question's answer key or every accepted spelling of a fill-in-the-blank answer, timing how long a visitor took over a quiz run — and for building quizzes — starting a new quiz from its title with a free address slug, finding which easy_flow host runs the quizzes, letting a builder upload a CSV file of true/false and multiple choice questions into a quiz through ixport, limiting that upload to the builder's own quizzes, adding one uploaded question to a quiz, reading or replacing the explanations an admin sees beside a question's answer settings, and reading which question_kit version is loaded — MUST BE USED instead of summing answer weights by hand, comparing typed answers to accepted answers in host code, picking out right answers from a step's answer list, subtracting run timestamps, making a quiz slug from its title, writing a CSV question importer or a loop that adds question steps to a flow, or writing a permission check for uploading into a quiz.
tools: Bash, Read, Write, Edit, Grep
scope: shared question and answer rules for easy_flow quizzes — what an answer to a question step is worth, which answers are right, and how a quiz is built
---

This local writes host app code that scores, keys, times and builds easy_flow quizzes through question_kit's declared interface only, and follows the steps below in order.

## What question_kit is

A Rails gem for apps that run quizzes as easy_flow flows on one easy_flow host, the flow host. It holds the rules those apps share: what an answer to a question step is worth, which answers are right, how long a visitor took, how a new quiz gets its slug, how a CSV file of questions becomes question steps, and the explanations an admin sees beside a question's answer settings. The scoring, key and timing methods take plain step hashes and answer values, or an easy_flow run, and write nothing. Use this local whenever host code needs a score, an answer key, a time taken, a new quiz, or a question upload. Flows, step types, runs and answers in general belong to the easy_flow locals, and ixport's own pages and configuration belong to the ixport locals.

## Interface

- `QuestionKit::VERSION` — a string such as `"0.2.0"` naming the question_kit release loaded in the host app.
- `QuestionKit::Score.worth(step, value)` — returns the integer one answer `value` to the step hash `step` is worth.
- `QuestionKit::Score.total(answers, steps)` — returns the integer sum of the worth of every answer in a run.
- `QuestionKit::Score.right_answers(step)` — returns the list of answer values on a choice step that carry a positive weight.
- `QuestionKit::AnswerKey.chosen(step)` — returns the answer key to show for a step: one value, a list of values, or `nil`.
- `QuestionKit::AnswerKey.accepted(step)` — returns every non-blank accepted answer on a fill-in-the-blank step.
- `QuestionKit::TimeTaken.seconds(run)` — returns the whole seconds from a run's start to its last answer, or `nil`.
- `QuestionKit.flow_host` — returns the name of the easy_flow host that runs the app's quizzes, exactly as the install set it, or `nil` when none is set.
- `QuestionKit::TitledStart.new(flow).save` — gives an unsaved quiz a slug made from its title and saves it, returning `true` or `false`.
- `QuestionKit::UploadedQuestion` — one row of a question upload: validates it and, once valid, adds it to the quiz as a question step.
- `QuestionKit::UploadedQuestion::ANSWER_FIELDS` — the six answer field names, `:answer_1` to `:answer_6`, a row may fill.
- `QuestionKit::UploadedQuestions.new(flow)` — the set of uploaded rows for one quiz, which builds an `UploadedQuestion` bound to that quiz from a row's values.
- `QuestionKit::QuestionImporter` — the ixport importer class that turns each row of a CSV file into a question step in the quiz the upload targets.
- `QuestionKit::QuestionImporter.allows?(account, quiz)` — returns whether `account` may upload questions into `quiz`.
- `QuestionKit::AnswerExplanations` — the explanations question_kit adds to the flow host's answer settings, which an admin sees beside each field.
- `QuestionKit::AnswerExplanations::TEXT` — a frozen hash from step type to setting to the explanation text question_kit shows.

## The step hash

Every scoring, key and timing method that takes a `step` takes the step's settings as a hash with string keys, as easy_flow stores them in a flow's document. Pass the hash, not a record.

- `"type"` decides how it is read: `"multiple_select"`, `"fill_in_the_blank"`, or any other value (or none) for a single-choice question.
- A choice step lists its answers under `"answers"` or `"options"`, each a hash with a `"value"` and an optional `"weight"`. A weight may be an integer or a string of digits, and a missing weight counts as 0.
- A fill-in-the-blank step lists its accepted answers under `"accepted_answers"`, each a hash with a `"value"`.

## How to use it

### Before any of it

1. Confirm question_kit is in the host app's `Gemfile.lock`. If it is not, hand the work to `question_kit-install` and stop.
2. At the top of the file that calls question_kit, require it explicitly:

   ```ruby
   require "question_kit"
   ```

   This also loads easy_flow, so no separate `require "easy_flow"` is needed.
3. Confirm `QuestionKit.flow_host` returns a host name in the app, for example with `bin/rails runner 'p QuestionKit.flow_host'`. Starting a quiz, uploading questions and the answer explanations all depend on it. If it prints `nil`, hand the work to `question_kit-install` and stop.

### Scoring, keying and timing a run

4. Put the calls in host code that reads a finished or stored run, such as a results page's controller, a model method on the app's own quiz record, or a job that records a score. Ask the developer where the score is used and whether it is shown only or also stored; do not pick.
5. Build the arguments from the flow version the run was taken on, not from the flow's live version, so a later edit does not change an old run's score:
   - `steps` is a hash from step id (string) to that step's settings hash.
   - `answers` is a hash from step id to the value the visitor gave. Ids may be strings or symbols.
6. Score one answer with `QuestionKit::Score.worth(step, value)`:
   - Single-choice: `value` is the chosen answer's value, and the result is that answer's weight, or 0 when it carries none or matches no answer.
   - Multiple-select: `value` is the list of ticked values, and the result is 1 when they are exactly the right answers in any order and 0 otherwise. Partial credit is not given.
   - Fill-in-the-blank: `value` is the typed text, and the result is 1 when it matches an accepted answer after removing outer spaces and ignoring letter case, and 0 otherwise.
7. Score a whole run with `QuestionKit::Score.total(answers, steps)`. An answer whose step id is not in `steps` counts 0, so steps that are not questions, such as info or branch steps, can be left in `answers` or taken out.
8. Ask the developer whether a score of 0 for a single-choice question with no weights set is correct for their quizzes, or whether every quiz must set weights before it is published. question_kit cannot tell an unweighted question from a wrong answer.
9. Show what was right:
   - `QuestionKit::Score.right_answers(step)` for the full list of values with a positive weight on a choice step.
   - `QuestionKit::AnswerKey.chosen(step)` for the single thing to display as the key: the list of right values for multiple-select, the first accepted answer for fill-in-the-blank, and the first right value for any other question. It returns `nil` when there is none, so render that case.
   - `QuestionKit::AnswerKey.accepted(step)` for every accepted spelling on a fill-in-the-blank step, with blank entries left out.
10. Time a run with `QuestionKit::TimeTaken.seconds(run)`, passing the easy_flow run record. It returns `nil` when the run's flow saves answers only once the flow ends, and when no step has been completed yet; render both cases, for example as "not timed".

### Starting a new quiz

11. In the host app's action that creates a quiz, build an unsaved `EasyFlow::Definition` with the flow host, the owner and the title the builder typed, and save it through `TitledStart` instead of calling `save` on it:

    ```ruby
    quiz = EasyFlow::Definition.new(host: QuestionKit.flow_host.to_s, owner: current_owner, title: params[:title])

    if QuestionKit::TitledStart.new(quiz).save
      redirect_to ...
    else
      render :new, status: :unprocessable_entity
    end
    ```

    `current_owner` stands for whatever record owns the host's flows; ask the developer which method returns it, or pass no owner when the host keeps none.
12. Read the result:
    - A blank title is refused: `save` returns `false` and `quiz.errors` holds a blank error on `:title`. Render the form with that error.
    - Otherwise the quiz takes a slug made from its title, lower case with hyphens, at most 100 characters and never ending on a hyphen. A title with no usable letters or digits gets `quiz`.
    - When the same host and owner already have that slug, or the slug is `manage`, `pages` or `runs`, the quiz takes the first free numbered slug, such as `morning-routine-2`.
    - `save` then returns what saving the flow returns, so any other validation error on the flow comes back as `false` with its errors.
    - When another quiz takes the same slug at the same moment, it tries the next free slug, and after three lost tries it raises `ActiveRecord::RecordNotUnique`. Ask the developer whether to let that error reach the error page or rescue it and show the form again.
13. Never set `slug` yourself when using `TitledStart`; it replaces any slug already on the flow.

### Uploading questions into a quiz

`QuestionKit::QuestionImporter` is defined only when ixport is loaded in the app. In an app without ixport, it does not exist, and nothing in this section applies. If the developer asks for question uploads and ixport is missing, hand adding ixport to `ixport-install`.

14. Register the upload with ixport in an initializer that runs after the ixport configuration, naming the importer by its string and limiting it with `allows?`:

    ```ruby
    Ixport.register_import :quiz_questions, title: "Quiz questions", importer: "QuestionKit::QuestionImporter", refuse_whole_file: true,
      allow: ->(_person, account, quiz) { QuestionKit::QuestionImporter.allows?(account, quiz) }
    ```

    Ask the developer for the key and the title the builder sees. Ask whether one bad row refuses the whole file (`refuse_whole_file: true`) or only that row; refusing the whole file is the setting that keeps a quiz from gaining half a file of questions.
15. `allows?(account, quiz)` returns `true` only when `quiz` is an easy_flow flow on the flow host and, when the flow host keeps owners, `quiz.owner` is `account`. A flow host with no owner method lets any account upload into any of its quizzes. ixport answers a refused upload page with not found.
16. Link a builder to the upload page from the quiz's own page, passing the quiz as the target by its global id. Hand the link and ixport's pages to `ixport-develop`:

    ```ruby
    ixport.new_import_path(key: :quiz_questions, target: quiz.to_global_id)
    ```

17. Tell the developer what the file must hold, since the builder's columns are matched to these fields on ixport's column-matching page:
    - `Type` — `True/false` or `Multiple choice`. Letter case, spaces, slashes and other non-letters are ignored, so `truefalse` and `multiple-choice` also match. Any other type refuses the row.
    - `Question` — the question text. A blank question refuses the row.
    - `Category` — optional; saved as the question's category when filled.
    - `Answer 1` to `Answer 6` — the answers of a multiple choice question, of which at least two must be filled. A true/false question ignores them and always offers `True` and `False`.
    - `Right answer` — for multiple choice, the number of the filled answer that is right, such as `2`; for true/false, `true` or `false` in any letter case. A right answer that names no answer refuses the row.
18. Each accepted row becomes a single-choice question step whose right answer has weight 1 and every other answer weight 0, so `Score.worth` scores it 1 or 0. Every row is added as a new question; an upload never matches or updates an existing question.
19. Each question is added to the quiz's draft, after the last question a visitor can reach and before whatever step followed it, and is recorded in the quiz's edit history as an added step. Visitors are asked the uploaded questions only once the quiz is published. Tell the developer that the builder must publish after uploading.

### Adding one question outside an upload

20. To add a single question from host code in the same way an upload row does, build it through `UploadedQuestions` and check it before saving, since `save!` does not validate:

    ```ruby
    question = QuestionKit::UploadedQuestions.new(quiz).new(type: "Multiple choice", question: "Which planet is largest?", category: "Space",
                                                            answer_1: "Mars", answer_2: "Jupiter", right_answer: "2")

    if question.valid?
      question.save!
    else
      question.errors.full_messages
    end
    ```

    The accepted keys are `type`, `question`, `category`, `right_answer` and each name in `QuestionKit::UploadedQuestion::ANSWER_FIELDS`. The rules in step 17 and the placement in step 19 apply. Build the answer keys from `ANSWER_FIELDS` rather than typing `answer_1` to `answer_6`.

### Answer explanations

21. question_kit adds its explanations to the flow host's answer settings by itself once the install sets the flow host, so an admin sees them beside each answer field on the canvas. Write no code to turn them on.
22. They cover the `question` step's answer value, label, hint, info and weight, the `multiple_select` step's answer value, label and weight, and the `fill_in_the_blank` step's accepted answer value. Read the exact text from `QuestionKit::AnswerExplanations::TEXT`, for example `QuestionKit::AnswerExplanations::TEXT["question"]["answers.weight"]`.
23. To show different words for a field, set it in the flow host's own setting explanations, keyed by step type and then by the same setting name `TEXT` uses. The host app's text replaces question_kit's for that field only, and question_kit's text stays on every other field:

    ```ruby
    EasyFlow.host_named(QuestionKit.flow_host).setting_explanations = { question: { "answers.weight" => "Points for this answer." } }
    ```

    Ask the developer which fields to reword and the words to use. Other easy_flow hosts get none of question_kit's explanations.

### Versions and tests

24. When code depends on a release, compare versions with `Gem::Version`, never as strings:

    ```ruby
    Gem::Version.new(QuestionKit::VERSION) >= Gem::Version.new("0.2.0")
    ```

    Ask the developer what the app does when the loaded version is older: raise at boot, log a warning, or skip the feature.
25. Write host app tests that assert the app's own behaviour with the score, key, time, new quiz or upload, such as what the results page shows or that a builder cannot reach another owner's upload page, and run them. Do not test question_kit's own scoring, slug or row rules.

## Conventions

- Never compute a score, a right answer or a time taken in host code. Call question_kit so every app scores the same way.
- Never compare a typed answer to an accepted answer in host code; `Score.worth` already ignores case and outer spaces.
- Never mutate the step hash passed in.
- Never make a quiz slug in host code; save a new quiz through `TitledStart`.
- Never write a question importer, a CSV parser for questions or a loop that adds question steps; register `QuestionKit::QuestionImporter` with ixport.
- Always pass `allows?` as the upload's access rule, so a builder cannot upload into another owner's quiz or a flow on another host.
- Never call `UploadedQuestion#save!` on a row that has not passed `valid?`.
- Never edit `QuestionKit::AnswerExplanations::TEXT` or extend a host with `AnswerExplanations` yourself; reword a field through the host's setting explanations.
- Compare `QuestionKit.flow_host` with a flow's host as a string, with `.to_s`.
- Never hard-code or redefine `QuestionKit::VERSION`.
- question_kit does not store scores, add step types, or upload multiple-select or fill-in-the-blank questions. If the developer asks for that, say so and ask whether to build it in the host app or wait for question_kit to add it.
- Adding or upgrading the gem and setting the flow host belong to `question_kit-install`.
- Flows, step types, runs, publishing and answers belong to the easy_flow locals.
- Adding ixport and its pages, links and configuration belong to the ixport locals.
