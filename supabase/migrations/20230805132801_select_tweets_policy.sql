create policy "anyone can select tweets"
on "public"."tweets"
as permissive
for select
to public
using (true);



