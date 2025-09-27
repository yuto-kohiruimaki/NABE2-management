# timestamp形式移行の本番デプロイ手順

## 概要
`start_time_h/start_time_m`等の分割カラムから`start_time/finish_time`のdatetime形式への移行を本番環境に反映する手順書。

## 前提条件
- devブランチでマイグレーション(`20250826135011_convert_time_fields_to_timestamp.rb`)が完成している
- mainブランチへのマージ後、Render.comが自動デプロイを実行する

---

## デプロイ手順

### 1. mainブランチへのマージ

```bash
git checkout main
git merge dev
git push origin main
```

### 2. Render.comでの自動デプロイ確認

1. [Render.comダッシュボード](https://dashboard.render.com/)にアクセス
2. 該当サービスのデプロイログを確認
3. デプロイが完了するまで待機（通常3-5分）

**確認ポイント**:
- ✅ Build成功
- ✅ デプロイ完了
- ⚠️ マイグレーションは**まだ実行されていない**（手動実行が必要）

---

### 3. 本番データベースのバックアップ（必須）

Render.comのShellまたはローカルから実行:

```bash
# Render.com Shell経由
rails db:backup

# または手動バックアップ（PostgreSQLの場合）
pg_dump $DATABASE_URL > backup_$(date +%Y%m%d_%H%M%S).sql
```

**重要**: バックアップファイルをローカルにダウンロードして保存すること。

---

### 4. マイグレーション前の確認

```bash
# Render.com Shellにアクセス
rails console

# 現在のデータ件数確認
Timestamp.count
Post.count

# サンプルデータ確認
Timestamp.first
Post.first

# マイグレーションステータス確認
exit
rails db:migrate:status
```

---

### 5. マイグレーション実行

```bash
rails db:migrate
```

**実行内容**:
- `timestamps`テーブル: `start_time_h/m`, `finish_time_h/m` → `start_time`, `finish_time` (datetime)
- `timestamps`テーブル: `year/month/date` → `work_date` (date)
- `posts`テーブル: `year/month/date` → `post_date` (date)
- インデックス追加: `user_id`, `work_date`, `post_date`等

---

### 6. マイグレーション後のデータ検証

```bash
rails console
```

**検証スクリプト**:

```ruby
# 1. 件数の一致確認
puts "Timestamps: #{Timestamp.count}"
puts "Posts: #{Post.count}"

# 2. 新しいカラムにデータが正しく移行されているか
timestamp = Timestamp.where.not(start_time: nil).first
puts "Work Date: #{timestamp.work_date}"
puts "Start Time: #{timestamp.start_time}"
puts "Finish Time: #{timestamp.finish_time}"

post = Post.where.not(post_date: nil).first
puts "Post Date: #{post.post_date}"

# 3. 古いカラムが削除されているか（エラーが出ればOK）
begin
  Timestamp.first.start_time_h
rescue NoMethodError
  puts "✅ 古いカラム(start_time_h)は正常に削除されています"
end

# 4. 終了時刻が開始時刻より後であることを確認（翌日処理の確認）
late_night_work = Timestamp.where.not(start_time: nil, finish_time: nil)
  .where("finish_time > start_time")
  .count
puts "正常なタイムスタンプ: #{late_night_work}件"

# 5. NULL値の確認
null_dates = Timestamp.where(work_date: nil).count
puts "work_dateがNULLのレコード: #{null_dates}件"
```

---

### 7. アプリケーション動作確認

1. **勤怠入力画面**: 新規作成・編集が正常に動作するか
2. **勤怠一覧画面**: 日付・時刻が正しく表示されるか
3. **ユーザー詳細画面**: 過去のデータが正しく表示されるか

**確認URL**:
- `/times/new` - 新規作成
- `/times` - 一覧表示
- `/users/:id` - ユーザー詳細

---

## トラブルシューティング

### ケース1: マイグレーションが失敗した場合

```bash
# ロールバック実行
rails db:rollback

# バックアップから復元（PostgreSQLの場合）
psql $DATABASE_URL < backup_YYYYMMDD_HHMMSS.sql
```

### ケース2: データが正しく移行されていない場合

```bash
# Railsコンソールでデータ修正
rails console

# 例: 特定レコードの再変換
timestamp = Timestamp.find(123)
# 手動でデータ修正...
timestamp.save!
```

### ケース3: アプリケーションエラーが発生した場合

1. Render.comのログを確認
2. エラー内容に応じてコード修正
3. 修正後、再デプロイ

```bash
git add .
git commit -m "Fix: timestamp migration error"
git push origin main
```

---

## ロールバック手順（緊急時）

### 完全ロールバック

```bash
# 1. マイグレーションのロールバック
rails db:rollback

# 2. バックアップから復元
psql $DATABASE_URL < backup_YYYYMMDD_HHMMSS.sql

# 3. 古いバージョンに戻す
git revert HEAD
git push origin main
```

### 注意事項
- ロールバック後、新形式で入力されたデータは失われる可能性あり
- ロールバックは**最終手段**として使用

---

## チェックリスト

### デプロイ前
- [ ] devブランチでマイグレーションが正常動作することを確認
- [ ] コードレビュー完了
- [ ] mainブランチにマージ

### デプロイ中
- [ ] Render.comの自動デプロイ完了を確認
- [ ] データベースバックアップ取得完了
- [ ] マイグレーションステータス確認

### デプロイ後
- [ ] マイグレーション実行完了
- [ ] データ件数の一致確認
- [ ] 新しいカラムへのデータ移行確認
- [ ] 古いカラムの削除確認
- [ ] アプリケーション動作確認（新規作成・一覧・詳細）
- [ ] エラーログ確認

---

## 関連ファイル

- マイグレーションファイル: `db/migrate/20250826135011_convert_time_fields_to_timestamp.rb`
- スキーマファイル: `db/schema.rb`
- モデル: `app/models/timestamp.rb`, `app/models/post.rb`

---

## 連絡先

問題が発生した場合は、すぐに開発チームに連絡してください。