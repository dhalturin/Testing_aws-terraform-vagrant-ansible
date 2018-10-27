DROP TABLE IF EXISTS "data";
CREATE TABLE "public"."data" (
    "path" text NOT NULL,
    "ip" text NOT NULL,
    "date" timestamp NOT NULL
) WITH (oids = false);
