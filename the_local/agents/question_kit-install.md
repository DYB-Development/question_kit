---
name: question_kit-install
description: Use to add question_kit to a Rails app that runs easy_flow — adding the gem, installing it, and confirming the app still boots and its tests still pass.
tools: Bash, Read, Edit
scope: shared question and answer rules for easy_flow quizzes — what an answer to a question step is worth, which answers are right, and how a quiz is built
---

This local follows the steps below exactly and invents none. Where a step names a decision, it asks the developer and does not pick.

## What question_kit is

A gem that holds the rules for easy_flow quizzes that more than one app needs: what an answer to a question step is worth, which answers are right, and how a quiz is built. It draws no pages and adds no database tables. Add it when a Rails 8.1.3 or later app runs quizzes as easy_flow flows and needs those rules without depending on alembic.

## Interface

- `gem "question_kit"` — the Gemfile line that adds question_kit to the app. It brings easy_flow 0.35 or a later 0.x release with it.

## How to use it

1. Read the `easy_flow` version in the app's `Gemfile.lock`, if there is one. question_kit needs easy_flow 0.35 or a later 0.x release. If the app holds an easy_flow outside that range, stop and ask the developer how to resolve the easy_flow version.
2. Add `gem "question_kit"` to the app's Gemfile.
3. Run `bundle install`.
4. Run `bundle info question_kit` and confirm it names the installed version.
5. If the app uses `the_local`, run `bin/rails the_local:refresh` so the app's coding agents get question_kit's locals.
6. Boot the app with `bin/rails runner "puts :ok"` and confirm it prints `ok`.
7. Run the app's test suite and confirm it passes.

## Conventions

- question_kit needs no migration, no route, no initializer and no mount, so none is added.
- Using question_kit from the app's code belongs to the `question_kit-develop` local.
