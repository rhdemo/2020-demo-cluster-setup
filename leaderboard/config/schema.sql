DROP TABLE IF EXISTS "public"."games" CASCADE ;
CREATE TABLE "public"."games" (
    "game_id" character varying(255) NOT NULL,
    "game_config" json,
    "game_date" timestamptz,
    "game_state" character varying(10) NOT NULL
) WITH (oids = false);


DROP TABLE IF EXISTS "public"."players";
CREATE TABLE "public"."players" (
    "player_id" character varying(255) NOT NULL,
    "player_name" character varying(255) NOT NULL,
    "guess_right" integer NOT NULL,
    "guess_wrong" integer NOT NULL,
    "guess_score" integer NOT NULL,
    "creation_server" character varying(255) NOT NULL,
    "game_server" character varying(255) NOT NULL,
    "scoring_server" character varying(255) NOT NULL,
    "player_avatar" json NOT NULL,
    "game_id" character varying(255) NOT NULL
) WITH (oids = false);


-- Create Constraints

ALTER TABLE "public"."games" ADD CONSTRAINT "games_pkey"  PRIMARY KEY ("game_id");

ALTER TABLE "public"."players" ADD CONSTRAINT "player_pkey"  PRIMARY KEY ("player_id");

ALTER TABLE "public"."players" ADD CONSTRAINT "players_game_id_fkey" FOREIGN KEY (game_id) REFERENCES games(game_id) NOT DEFERRABLE;

-- Create Indexes

CREATE INDEX "idx_game_state" ON "public"."games" USING btree ("game_state");

CREATE INDEX "idx_creation_server" ON "public"."players" USING btree ("creation_server");

CREATE INDEX "idx_game_id" ON "public"."players" USING btree ("game_id");

CREATE INDEX "idx_game_server" ON "public"."players" USING btree ("game_server");

CREATE INDEX "idx_player_id" ON "public"."players" USING btree ("player_id");

CREATE INDEX "idx_scoring_server" ON "public"."players" USING btree ("scoring_server");