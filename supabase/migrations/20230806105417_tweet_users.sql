drop policy "anyone can select tweets" on "public"."tweets";

alter table "public"."tweets" add column "user_id" uuid not null;

alter table "public"."tweets" add constraint "tweets_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."tweets" validate constraint "tweets_user_id_fkey";

create policy "authenticated users can select tweets"
on "public"."tweets"
as permissive
for select
to authenticated
using (true);



