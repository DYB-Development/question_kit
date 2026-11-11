---
name: question_kit-info
description: Use to learn what question_kit offers — shared rules for easy_flow quizzes, covering what an answer to a question step is worth, which answers are right, the answer key a quiz shows for each question, and how long a visitor took on a quiz.
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
- report how long a visitor took to answer the quiz.

It reads the steps and runs easy_flow already stores. It adds no tables, no
pages and no step types of its own.

## Interface

This local documents no commands. The other two locals cover everything the
gem exposes:

- The install local, `question_kit-install`, adds the gem to a host app.
- The develop local, `question_kit-develop`, covers the scoring, answer key and
  time rules a host app calls.

Anything about building or running the flows themselves, such as the canvas,
step types, runs and recorded answers, belongs to easy_flow. The easy_flow
locals cover that.

## How to use it

- To add question_kit to an app, use `question_kit-install`.
- To score answers, show an answer key or time a quiz in an app, use
  `question_kit-develop`.
- To build the quiz flow or a question step, use the easy_flow locals.

## Conventions

- **Quiz** — an easy_flow flow whose steps ask the visitor questions.
- **Host app** — the Rails app that installs question_kit and easy_flow and runs
  the quizzes.
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
