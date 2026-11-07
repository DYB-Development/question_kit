---
name: question_kit-install
description: Use to hook question_kit into a project — adding the gem to the host app's Gemfile and installing it alongside easy_flow.
tools: Bash, Read, Edit
scope: shared question and answer rules for easy_flow quizzes — what an answer to a question step is worth, which answers are right, and how a quiz is built
---

This local follows these steps exactly and invents none.

## What question_kit is

A Rails gem holding the shared quiz rules for apps that run quizzes as easy_flow flows, hooked in when a host app runs easy_flow quizzes.

## Interface

- `gem "question_kit"` — the Gemfile line that adds question_kit, and with it easy_flow, to the host app.

## How to use it

1. Check the host app's Rails version in `Gemfile.lock`. question_kit needs Rails 8.1.3 or later, so stop and tell the developer if the app is older.
2. Check `Gemfile.lock` for easy_flow. question_kit needs easy_flow 0.35 or a later 0.x release. If the app pins an easy_flow version outside that range, ask the developer whether to move the pin before going on.
3. Add the gem to the host app's `Gemfile`:

   ```ruby
   gem "question_kit"
   ```

4. Run:

   ```
   bundle install
   ```

   This edits `Gemfile.lock` and brings in easy_flow if the app did not have it.
5. Check whether easy_flow is already hooked into the app: its migrations copied and run, its engine mounted, and its hosts declared. If any of that is missing, hand the work to `easy_flow-install`, and ask the developer which hosts to declare rather than picking them.

question_kit has no generator, no initializer, no migrations and no routes of its own. Requiring the gem loads easy_flow, so the host app needs no separate `require "easy_flow"`.

## Conventions

- After install, run `bundle list | grep -E "question_kit|easy_flow"` and confirm both gems are listed.
- After a `bundle update question_kit`, check `Gemfile.lock` again for the easy_flow version it brought in, and run `easy_flow-install` for any new easy_flow migrations.
- Setting up easy_flow itself, its hosts, step types and admin pages belongs to `easy_flow-install`.
- Writing code against question_kit belongs to `question_kit-develop`.
