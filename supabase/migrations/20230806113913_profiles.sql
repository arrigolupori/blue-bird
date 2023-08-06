alter table "public"."tweets" drop constraint "tweets_user_id_fkey";

create table "public"."profiles" (
    "id" uuid not null,
    "name" text not null,
    "username" text not null,
    "avatar_url" text not null
);


alter table "public"."profiles" enable row level security;

CREATE UNIQUE INDEX profiles_pkey ON public.profiles USING btree (id);

alter table "public"."profiles" add constraint "profiles_pkey" PRIMARY KEY using index "profiles_pkey";

alter table "public"."profiles" add constraint "profiles_id_fkey" FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."profiles" validate constraint "profiles_id_fkey";

alter table "public"."tweets" add constraint "tweets_user_id_fkey" FOREIGN KEY (user_id) REFERENCES profiles(id) ON DELETE CASCADE not valid;

alter table "public"."tweets" validate constraint "tweets_user_id_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.insert_profile_for_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$begin
  insert into public.profiles(id, name, username, avatar_url) values(
    new.id,
    new.raw_user_meta_data->>'name',
    new.raw_user_meta_data->>'user_name',
    new.raw_user_meta_data->>'avatar_url'
  );
  return new;
end;$function$
;

create policy "enable read access for profiles"
on "public"."profiles"
as permissive
for select
to public
using (true);



