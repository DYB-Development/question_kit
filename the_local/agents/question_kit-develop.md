---
name: question_kit-develop
description: Use PROACTIVELY for scoring an easy_flow quiz — working out what one answer to a question, multiple-select or fill-in-the-blank step is worth, adding up a run's total score, listing a question's right answers, showing a question's answer key or every accepted spelling of a fill-in-the-blank answer, timing how long a visitor took over a quiz run, and reading which question_kit version is loaded — MUST BE USED instead of summing answer weights by hand, comparing typed answers to accepted answers in host code, picking out right answers from a step's answer list, or subtracting run timestamps.
tools: Bash, Read, Write, Edit, Grep
scope: shared question and answer rules for easy_flow quizzes — what an answer to a question step is worth, which answers are right, and how a quiz is built
---

This local writes host app code that scores, keys and times easy_flow quizzes through question_kit's declared interface only, and follows the steps below in order.

## What question_kit is

A Rails gem for apps that run quizzes as easy_flow flows. It holds the rules those apps share: what an answer to a question step is worth, which answers are right, and how long a visitor took. Every method takes plain step hashes and answer values, or an easy_flow run, and returns a number, a value or a list; none of them writes anything. Use this local whenever host code needs a score, an answer key, a list of accepted answers or a time taken for a quiz. Building the flow, its steps, runs and answers belongs to the easy_flow locals.

## Interface

- `QuestionKit::VERSION` — a string such as `"0.1.0"` naming the question_kit release loaded in the host app.
- `QuestionKit::Score.worth(step, value)` — returns the integer one answer `value` to the step hash `step` is worth.
- `QuestionKit::Score.total(answers, steps)` — returns the integer sum of the worth of every answer in a run.
- `QuestionKit::Score.right_answers(step)` — returns the list of answer values on a choice step that carry a positive weight.
- `QuestionKit::AnswerKey.chosen(step)` — returns the answer key to show for a step: one value, a list of values, or `nil`.
- `QuestionKit::AnswerKey.accepted(step)` — returns every non-blank accepted answer on a fill-in-the-blank step.
- `QuestionKit::TimeTaken.seconds(run)` — returns the whole seconds from a run's start to its last answer, or `nil`.

## The step hash

Every method that takes a `step` takes the step's settings as a hash with string keys, as easy_flow stores them in a flow's document. Pass the hash, not a record.

- `"type"` decides how it is read: `"multiple_select"`, `"fill_in_the_blank"`, or any other value (or none) for a single-choice question.
- A choice step lists its answers under `"answers"` or `"options"`, each a hash with a `"value"` and an optional `"weight"`. A weight may be an integer or a string of digits, and a missing weight counts as 0.
- A fill-in-the-blank step lists its accepted answers under `"accepted_answers"`, each a hash with a `"value"`.

## How to use it

1. Confirm question_kit is in the host app's `Gemfile.lock`. If it is not, hand the work to `question_kit-install` and stop.
2. At the top of the file that calls question_kit, require it explicitly:

   ```ruby
   require "question_kit"
   ```

   This also loads easy_flow, so no separate `require "easy_flow"` is needed.
3. Put the calls in host code that reads a finished or stored run, such as a results page's controller, a model method on the app's own quiz record, or a job that records a score. Ask the developer where the score is used and whether it is shown only or also stored; do not pick.
4. Build the arguments from the flow version the run was taken on, not from the flow's live version, so a later edit does not change an old run's score:
   - `steps` is a hash from step id (string) to that step's settings hash.
   - `answers` is a hash from step id to the value the visitor gave. Ids may be strings or symbols.
5. Score one answer with `QuestionKit::Score.worth(step, value)`:
   - Single-choice: `value` is the chosen answer's value, and the result is that answer's weight, or 0 when it carries none or matches no answer.
   - Multiple-select: `value` is the list of ticked values, and the result is 1 when they are exactly the right answers in any order and 0 otherwise. Partial credit is not given.
   - Fill-in-the-blank: `value` is the typed text, and the result is 1 when it matches an accepted answer after removing outer spaces and ignoring letter case, and 0 otherwise.
6. Score a whole run with `QuestionKit::Score.total(answers, steps)`. An answer whose step id is not in `steps` counts 0, so steps that are not questions, such as info or branch steps, can be left in `answers` or taken out.
7. Ask the developer whether a score of 0 for a single-choice question with no weights set is correct for their quizzes, or whether every quiz must set weights before it is published. question_kit cannot tell an unweighted question from a wrong answer.
8. Show what was right:
   - `QuestionKit::Score.right_answers(step)` for the full list of values with a positive weight on a choice step.
   - `QuestionKit::AnswerKey.chosen(step)` for the single thing to display as the key: the list of right values for multiple-select, the first accepted answer for fill-in-the-blank, and the first right value for any other question. It returns `nil` when there is none, so render that case.
   - `QuestionKit::AnswerKey.accepted(step)` for every accepted spelling on a fill-in-the-blank step, with blank entries left out.
9. Time a run with `QuestionKit::TimeTaken.seconds(run)`, passing the easy_flow run record. It returns `nil` when the run's flow saves answers only once the flow ends, and when no step has been completed yet; render both cases, for example as "not timed".
10. When code depends on a release, compare versions with `Gem::Version`, never as strings:

    ```ruby
    Gem::Version.new(QuestionKit::VERSION) >= Gem::Version.new("0.2.0")
    ```

    Ask the developer what the app does when the loaded version is older: raise at boot, log a warning, or skip the feature.
11. Write host app tests that assert the app's own behaviour with the score, key or time, such as what the results page shows, and run them. Do not test question_kit's own scoring rules.

## Conventions

- Never compute a score, a right answer or a time taken in host code. Call question_kit so every app scores the same way.
- Never compare a typed answer to an accepted answer in host code; `Score.worth` already ignores case and outer spaces.
- Never mutate the step hash passed in.
- Never hard-code or redefine `QuestionKit::VERSION`.
- question_kit does not build quizzes, add step types or store scores. If the developer asks for that, say so and ask whether to build it in the host app or wait for question_kit to add it.
- Adding or upgrading the gem belongs to `question_kit-install`.
- Flows, step types, runs and answers belong to the easy_flow locals.
