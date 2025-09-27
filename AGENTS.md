# Repository Guidelines

## Project Structure & Module Organization
The application follows Rails 8 conventions. Domain logic sits in `app/models`, controllers in `app/controllers`, and view templates in `app/views`. JavaScript lives in `app/javascript` via import maps, and shared styles and images stay under `app/assets`. Background workers reside in `app/jobs`, while reusable helpers and mailers are in their namesake folders. Shared Ruby utilities belong in `lib/`. Database migrations and seeds live in `db/`, environment configuration in `config/`, and the test suite mirrors the runtime structure in `test/` with fixtures in `test/fixtures`.

## Build, Test, and Development Commands
- `bin/setup` installs gems, prepares the database, and clears stale artifacts.
- `bin/rails server` runs the app locally at `http://localhost:3000`.
- `bin/rails db:migrate` applies schema updates; pair with `bin/rails db:rollback` when reversing.
- `bin/rails test` executes the full suite; append paths such as `test/models/user_test.rb` to scope runs.
- `bin/rails assets:precompile` produces deployable assets (used by `bin/render-build.sh`).

## Coding Style & Naming Conventions
Target Ruby 3.4.2 and Rails 8 idioms. Use two-space indentation, trailing commas only when necessary, and wrap lines at ~100 characters. Favor `snake_case` for files, methods, and variables, with classes and modules in `CamelCase`. Keep controllers lean by extracting service objects or concerns under `app/services` or `app/controllers/concerns`. Keep HTML ERB views concise and offload formatting helpers to `app/helpers`.

## Testing Guidelines
Minitest backs unit, integration, and system coverage. Model tests live in `test/models`, controller specs in `test/controllers`, and UI flows under `test/system` using Capybara + Selenium. Name files `*_test.rb` and mirror the Ruby constant under test. Use fixtures from `test/fixtures` or builder helpers to craft data. Every feature or bug fix should introduce or update assertions protecting regressions. Run `bin/rails test` locally before pushing.

## Commit & Pull Request Guidelines
Recent history favors short, declarative commit messages (e.g., `DB設計変更`, `一覧に現場名追加`). Keep each commit focused on a single concern and describe the intent of the change. Reference ticket IDs or GitHub issues when available. Pull requests must summarize the impact, call out schema or configuration updates, include screenshots for UI tweaks, and note how reviewers can verify (`bin/rails test`). Ensure migrations are reversible and CI is green before requesting review.
