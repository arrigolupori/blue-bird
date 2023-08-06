create table "public"."tweets" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now(),
    "title" text not null
);


alter table "public"."tweets" enable row level security;

CREATE UNIQUE INDEX tweets_pkey ON public.tweets USING btree (id);

alter table "public"."tweets" add constraint "tweets_pkey" PRIMARY KEY using index "tweets_pkey";


