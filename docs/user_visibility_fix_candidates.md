# user_id に基づく表示制御で修正が必要な箇所

`docs/user_id_visibility.md` に記載されているうち、現在も生の `user_id` や特定ユーザー ID に依存して表示可否を決めている箇所を、`users.role` または `users.is_deleted` を用いた判定に置き換える必要があるポイントを整理した。

## ビュー
- `app/views/users/index.html.erb:14-29` – `user.id >= 3 && user.id != 6` という数値条件でカードの表示を制限している。ロールや `is_deleted` を使った判定へ変更する。
- `app/views/admin/users/index.html.erb:12-27` – 一般ユーザー一覧と同様の数値条件を利用しているため、ロール/`is_deleted` ベースの制御に差し替える。
- `app/views/times/show.html.erb:25-27` – `current_user.id == 3` のときのみ編集リンクを表示している。`current_user.admin?` などロール判定と `is_deleted` の考慮に切り替える。
- `app/views/users/show.html.erb:330-340` – `@user.id == 2` の場合にのみ診断用ブロックを表示している。不要なら削除し、必要であればロール/`is_deleted` での制御へ改修する。

## コントローラ（フォローアップ項目）
- 特定の `user_id` を前提としている処理や、退職者（`is_deleted` が true）を誤って対象に含める可能性がある箇所がないか再確認し、可能な範囲でロールヘルパーや `is_deleted` フラグを用いた判定へ移行する。

これらの修正が完了したら、`docs/user_id_visibility.md` も更新し、ロール/フラグに基づく最新の挙動を反映させること。
