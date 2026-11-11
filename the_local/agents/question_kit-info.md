---
name: question_kit-info
description: Use to learn what question_kit offers — shared rules for easy_flow quizzes, covering what an answer to a question step is worth, which answers are right, the answer key a quiz shows for each question, how long a visitor took on a quiz, starting a quiz from its title, adding questions to a quiz from an uploaded CSV file, and the explanations an admin sees beside a question's answer settings.
tools: Read
scope: shared question and answer rules for easy_flow quizzes — what an answer to a question step is worth, which answers are right, and how a quiz is built
---

This local explains question_kit and makes no changes.

## What question_kit is

question_kit is a Rails gem for apps that run quizzes as easy_flow flows. Each
quiz question is an easy_flow question step. The gem holds the rules those apps
share, so each app does not keep its own copy of them.

Reach for it when an app runs easy_flow quizzes and needs to:

- score a visitor's answer to one question, or add up a whole quiz;
- say which answers to a question are right;
- show the answer key for a question once the quiz is over;
- report how long a visitor took to answer the quiz;
- start a new quiz from the title an admin types;
- add questions to a quiz from a CSV file an admin uploads;
- explain to an admin, beside each answer setting on the canvas, what that
  setting does to the score.

It reads and writes the flows, steps and runs easy_flow already stores. It adds
no tables and no step types of its own. The CSV upload uses ixport's import
pages, and is only there in an app that has ixport.

## Interface

This local documents no commands. The other two locals cover everything the
gem exposes:

- The install local, `question_kit-install`, adds the gem to a host app and
  names the easy_flow host whose flows are quizzes.
- The develop local, `question_kit-develop`, covers scoring, the answer key,
  time taken, starting a quiz from its title, the question upload and the
  answer setting explanations.

Anything about building or running the flows themselves, such as the canvas,
step types, runs and recorded answers, belongs to easy_flow, and the easy_flow
locals cover it. The import pages themselves belong to ixport, and the ixport
locals cover them.

## How to use it

- To add question_kit to an app, use `question_kit-install`.
- To score answers, show an answer key, time a quiz, start a quiz from its
  title or offer the question upload, use `question_kit-develop`.
- To build the quiz flow or a question step by hand, use the easy_flow locals.

## Conventions

- **Quiz** — an easy_flow flow whose steps ask the visitor questions.
- **Host app** — the Rails app that installs question_kit and easy_flow and runs
  the quizzes.
- **Quiz host** — the one easy_flow host in the host app whose flows are
  quizzes. The answer setting explanations and the question upload apply to
  that host only.
- **Question step** — one easy_flow step that asks one question and records the
  visitor's answer. The rules know three kinds:
  - a **single choice** question, where the visitor picks one of the step's
    answers;
  - a **multiple select** question, where the visitor ticks several;
  - a **fill-in-the-blank** question, where the visitor types the answer.
- **Weight** — a number an admin sets on each answer of a choice question.
- **Right answer** — on a choice question, an answer whose weight is above
  zero.
- **Accepted answer** — on a fill-in-the-blank question, a text the admin lists
  as correct. An accepted answer left blank does not count.
- **Worth** — what one answer counts toward the quiz's result:
  - a single choice answer is worth the weight of the answer picked, and zero
    when it has none;
  - a multiple select answer is worth one when the ticked answers are exactly
    the right answers, and zero otherwise;
  - a fill-in-the-blank answer is worth one when it matches any accepted answer,
    ignoring capital letters and spaces at either end, and zero otherwise.
- **Total** — the sum of the worth of every answer in a run.
- **Answer key** — the answer a quiz shows as correct for a question: the first
  right answer of a single choice question, every right answer of a multiple
  select question, and the first accepted answer of a fill-in-the-blank
  question.
- **Time taken** — the seconds from the start of a visitor's run to the last
  answer they gave. A run with no answers has none. A flow that saves answers
  only when the visitor finishes, rather than after each step, records no
  time per answer, so its runs have no time taken.
- **Titled start** — saving a new quiz from its title alone. A blank title is
  refused. The quiz's address is made from the title, cut to 100 characters,
  and is `quiz` when the title holds nothing usable. When another quiz of the
  same host and owner already has that address, a number is added, starting at
  2. The words `manage`, `pages` and `runs` are never used as an address.
- **Uploaded question** — one row of a CSV file an admin uploads to a quiz. Its
  columns are Type, Question, Category, Answer 1 to Answer 6, and Right answer.
  - Type is true/false or multiple choice.
  - A true/false row gets the answers True and False, and its Right answer is
    true or false.
  - A multiple choice row needs at least two answers, and its Right answer is
    the number of one of them.
  - The right answer gets a weight of one and every other answer zero.
  - A row with no question, an unknown type or no right answer is refused.
- **Where uploaded questions go** — each one is added as a single choice
  question after the last question a visitor can reach, and is recorded in the
  quiz's edit history as an added step. It is added to the quiz's unpublished
  changes, so visitors are not asked it until the quiz is published.
- **Who may upload** — only to a quiz of the quiz host, and, when that host's
  flows each belong to an owner, only by the account that owns the quiz.
- **Answer setting explanation** — the line an admin sees beside a question's
  answer settings on the canvas, saying what the setting shows a player and
  what it does to the score. An explanation the host app gives itself is shown
  in place of question_kit's.
