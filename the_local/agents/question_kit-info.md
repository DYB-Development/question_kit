---
name: question_kit-info
description: Use to learn what question_kit offers — shared rules for easy_flow quizzes, covering what an answer to a question step is worth, which answers are right, and how a quiz is built.
tools: Read
scope: shared question and answer rules for easy_flow quizzes — what an answer to a question step is worth, which answers are right, and how a quiz is built
---

This local explains question_kit and makes no changes.

## What question_kit is

question_kit is a Rails gem for apps that run quizzes as easy_flow flows. Each
quiz question is an easy_flow question step. The gem is meant to hold the rules
those apps share: what an answer to a question step is worth, which answers are
right, and how a quiz is built. With the rules in one gem, each app does not
keep its own copy.

Today the gem holds none of those rules yet. It loads easy_flow into the host
app and reports its own version, and nothing more. Reach for it when an app
runs easy_flow quizzes and should follow the shared rules as they are added.
Until then, it is only a dependency to put in place.

## Interface

This local documents no commands. The other two locals cover everything the
gem exposes:

- The install local, `question_kit-install`, adds the gem to a host app.
- The develop local, `question_kit-develop`, covers the code a host app writes against the gem.

Anything about building or running the flows themselves, such as the canvas,
step types, runs and answers, belongs to easy_flow. The easy_flow locals cover
that.

## How to use it

- To add question_kit to an app, use `question_kit-install`.
- To write code that uses question_kit, use `question_kit-develop`.
- To build the quiz flow or a question step, use the easy_flow locals.

## Conventions

- **Quiz** — an easy_flow flow whose steps ask the visitor questions.
- **Question step** — one easy_flow step that asks one question and records the
  visitor's answer.
- **Worth** — what an answer is worth toward the quiz's result.
- **Right answer** — an answer the quiz counts as correct for its question.
- **Host app** — the Rails app that installs question_kit and easy_flow and runs
  the quizzes.
