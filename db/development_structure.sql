CREATE TABLE "categories" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "locales" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "iso_code" varchar(255), "name" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "open_id_authentication_associations" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "issued" integer, "lifetime" integer, "handle" varchar(255), "assoc_type" varchar(255), "server_url" blob, "secret" blob);
CREATE TABLE "open_id_authentication_nonces" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "timestamp" integer NOT NULL, "server_url" varchar(255), "salt" varchar(255) NOT NULL);
CREATE TABLE "passwords" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer, "reset_code" varchar(255), "expiration_date" datetime, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "roles" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255));
CREATE TABLE "roles_users" ("role_id" integer, "user_id" integer);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "sessions" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "session_id" varchar(255) NOT NULL, "data" text, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "login" varchar(40), "identity_url" varchar(255), "name" varchar(100) DEFAULT '', "email" varchar(100), "crypted_password" varchar(40), "salt" varchar(40), "remember_token" varchar(40), "activation_code" varchar(40), "state" varchar(255) DEFAULT 'passive' NOT NULL, "remember_token_expires_at" datetime, "activated_at" datetime, "deleted_at" datetime, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "word_representations" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "text" varchar(255), "word_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "words" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "locale_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE INDEX "index_categories_on_name" ON "categories" ("name");
CREATE UNIQUE INDEX "index_locales_on_iso_code" ON "locales" ("iso_code");
CREATE INDEX "index_sessions_on_session_id" ON "sessions" ("session_id");
CREATE INDEX "index_sessions_on_updated_at" ON "sessions" ("updated_at");
CREATE UNIQUE INDEX "index_users_on_login" ON "users" ("login");
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20080929171348');

INSERT INTO schema_migrations (version) VALUES ('20100202133147');

INSERT INTO schema_migrations (version) VALUES ('20100202135459');

INSERT INTO schema_migrations (version) VALUES ('20100202135540');

INSERT INTO schema_migrations (version) VALUES ('20100202212122');