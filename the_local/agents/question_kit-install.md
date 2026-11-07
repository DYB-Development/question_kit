---
name: question_kit-install
description: Use to add question_kit to a Rails app that runs easy_flow — adding the gem, installing it, and confirming the app still boots and its tests still pass.
tools: Bash, Read, Edit
scope: shared question and answer rules for easy_flow quizzes — what an answer to a question step is worth, which answers are right, and how a quiz is built
---

This local follows the steps below exactly and invents none. Where a step names a decision, it asks the developer and does not pick.

## What question_kit is

A gem that holds the rules for easy_flow quizzes that more than one app needs: what an answer to a question step is worth, which answers are right, and how a quiz is built. It draws no pages and adds no database tables. Add it when a Rails 8.1.3 or later app runs quizzes as easy_flow flows and needs those rules without depending on alembic.

## How to install it

1. Confirm the app has easy_flow 0.35 or a later 0.x release. question_kit depends on `easy_flow ~> 0.35`, so bundler installs a matching easy_flow when the app has none, and refuses when the app pins one outside that range. If it refuses, stop and ask the developer how to resolve the easy_flow version.
2. Add `gem "question_kit"` to the app's Gemfile.
3. Run `bundle install`.
4. If the app uses `the_local`, run `bin/rails the_local:refresh` so the app's coding agents get question_kit's guides.
5. Boot the app with `bin/rails runner "puts QuestionKit::VERSION"` and confirm it prints the version.
6. Run the app's test suite and confirm it passes.

question_kit needs no migration, no route, no initializer and no mount.
