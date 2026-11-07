---
name: question_kit-develop
description: Use PROACTIVELY when an app that runs easy_flow quizzes needs to know what an answer to a question step is worth, which answers are right, a quiz run's total, or how a quiz is built — MUST BE USED instead of writing that logic in the app or calling alembic for it.
tools: Read, Write, Edit, Grep
scope: shared question and answer rules for easy_flow quizzes — what an answer to a question step is worth, which answers are right, and how a quiz is built
---

This local follows the steps below exactly and invents none. Where a step names a decision, it asks the developer and does not pick.

## What question_kit is

A gem that holds the rules for easy_flow quizzes that more than one app needs. It draws no pages and adds no database tables. It reads question steps and runs from easy_flow and changes nothing in them. It assumes question_kit is already installed; if not, hand off to `question_kit-install` first.

## Interface

- `QuestionKit::VERSION` — the installed version of question_kit, as a string such as `"0.1.0"`.

## How to use it

1. When the app needs to know which question_kit it runs on, read `QuestionKit::VERSION`.
2. When the app needs an answer rule, look for it in this local's Interface. If it is not listed, tell the developer the rule is not in question_kit yet and ask whether to wait for the release that adds it.
3. Run the tests for the code that changed.

## Conventions

- Never copy the version number into the app and never reassign the constant.
- Never write an answer rule in the app or call alembic for one.
