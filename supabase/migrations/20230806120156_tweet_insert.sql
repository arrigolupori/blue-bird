create policy "authenticated users can insert their own tweets"
on "public"."tweets"
as permissive
for insert
to authenticated
with check ((user_id = auth.uid()));



