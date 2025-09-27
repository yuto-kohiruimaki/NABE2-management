# Visibility Control Refactor Tasks

| # | Task | Scope / Notes | Suggested Output |
| - | - | - | - |
| 1 | ルール整理 | `docs/user_id_visibility.md` をベースに、画面ごとのアクセス要件を `role` (`admin`/`employee`) と `is_deleted` の観点で再定義し、既存の `user.id` ハードコードの扱い方針を決める。 | 更新済み仕様コメントまたはチェックリスト |
| 2 | ドキュメント更新 | ルール整理の結果を反映し、`user_id` 依存の説明をロール/フラグ中心の表現に差し替える。 | `docs/user_id_visibility.md` の更新 |
| 3 | コントローラ修正 | `PostsController#authorize_post!`, `TimesController` (index/authorize/owner_user_id), `HomeController#index`, `UsersController#authorize_user!` などの `user_id` 比較を `current_user.admin?` や `current_user.active?` などロール・フラグに基づく判定へリファクタ。 | 更新済みコントローラ + コメント |
| 4 | ビュー修正 | `app/views/times/index.html.erb`, `app/views/times/show.html.erb`, `app/views/users/index.html.erb`, `app/views/admin/users/index.html.erb` 等の表示制御をロール/フラグベースに変更し、`user.id` のハードコードを廃止。 | 更新済みビュー |
| 5 | テスト整備 | `test/models/user_test.rb`, 関連コントローラ/システムテストを追加・更新し、`role` と `is_deleted` によるアクセス制御を検証。 | 追加・更新テスト |
| 6 | リグレッションチェック | `bin/rails test` の実行および必要に応じた手動確認（admin / employee / is_deleted ユースケース）を行う。 | テスト結果ログ & 動作確認メモ |
