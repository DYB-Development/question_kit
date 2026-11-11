---
name: question_kit-install
description: Use to hook question_kit into a project — adding the gem to the host app's Gemfile alongside easy_flow, and naming the easy_flow host whose flows are the app's quizzes.
tools: Bash, Read, Edit
scope: shared question and answer rules for easy_flow quizzes — what an answer to a question step is worth, which answers are right, and how a quiz is built
---

This local follows these steps exactly and invents none.

## What question_kit is

A Rails gem holding the shared quiz rules for apps that run quizzes as easy_flow flows, hooked in when a host app runs easy_flow quizzes.

## Interface

- `gem "question_kit"` — the Gemfile line that adds question_kit, and with it easy_flow, to the host app.
- `QuestionKit.flow_host = name` — names the easy_flow host whose flows are the app's quizzes, so that host's admin settings for answers carry question_kit's explanations and quiz questions are uploaded only into that host's flows.

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
6. Find the easy_flow host declarations in the app's initializers, the `EasyFlow.host(:name)` lines. Ask the developer which declared host runs the quizzes. Never pick one, even when only one host is declared.
7. Set that host as question_kit's flow host, in `config/initializers/question_kit.rb`:

   ```ruby
   QuestionKit.flow_host = :quizzes
   ```

   Use the host's name exactly as its `EasyFlow.host` line spells it. The line must run after that `EasyFlow.host` line. Rails runs initializers in alphabetical order by file name, so when the host is declared in a file that sorts after `question_kit.rb`, put the line in that file, directly below the declaration, instead of in a file of its own.

question_kit has no generator, no migrations and no routes of its own. Requiring the gem loads easy_flow, so the host app needs no separate `require "easy_flow"`.

## Conventions

- After install, run `bundle list | grep -E "question_kit|easy_flow"` and confirm both gems are listed.
- After install, boot the app with `bin/rails runner 'puts QuestionKit.flow_host'` and confirm it prints the host name chosen in step 6.
- One app has one quiz host. To move the quizzes to another host, change the name in the `QuestionKit.flow_host` line and nowhere else.
- After a `bundle update question_kit`, check `Gemfile.lock` again for the easy_flow version it brought in, and run `easy_flow-install` for any new easy_flow migrations.
- Setting up easy_flow itself, its hosts, step types and admin pages belongs to `easy_flow-install`.
- Registering the quiz question upload with ixport, and writing code against question_kit, belong to `question_kit-develop`.
