# User ID-Based Visibility Controls

This document lists the spots where the UI or controller logic hides or shows data based on `user_id` (or the signed-in user's id).

## Controllers
- `app/controllers/posts_controller.rb:62-64` – `authorize_post!` only permits admins or the post owner (`@post.user_id == current_user.id`) to view, edit, or delete a post. Others are redirected.
- `app/controllers/times_controller.rb:7-10` – `index` limits the timestamp list to the signed-in user's records unless the user is an admin.
- `app/controllers/times_controller.rb:120-124` – `authorize_timestamp!` ensures only admins or the timestamp owner (`@timestamp.user_id == current_user.id`) can access edit/show/destroy actions.
- `app/controllers/times_controller.rb:127-128` – `owner_user_id` chooses which `user_id` to redirect back to after updates/deletes, keeping non-admins scoped to their own data.
- `app/controllers/home_controller.rb:49-59` – The calendar view restricts schedules to the current user's posts unless the user is an admin.
- `app/controllers/users_controller.rb:104-113` – `set_user`/`authorize_user!` allow access to a user's detail page only for admins or the matching user (`current_user == @user`), redirecting others.

## Views
- `app/views/times/index.html.erb:12-14` – The "再入力" link is rendered only when the viewer is an admin or owns the timestamp (`timestamp.user_id == current_user.id`).
- `app/views/times/show.html.erb:25-27` – The "修正画面へ" link appears only for the timestamp owner (`@userId == current_user.id`) or when the viewer has the hard-coded admin id `3`.
- `app/views/users/index.html.erb:14-29` – The user list hides cards for `user.id < 3` and for `user.id == 6`, effectively limiting which users appear.
- `app/views/admin/users/index.html.erb:12-27` – The admin user list follows the same `user.id >= 3 && user.id != 6` constraint when showing cards.
- `app/views/users/show.html.erb:330-340` – A diagnostic block showing date/time metadata is only rendered when `@user.id == 2`.

If additional guards are added, please update this document so we keep a single reference of `user_id`-based visibility rules.
