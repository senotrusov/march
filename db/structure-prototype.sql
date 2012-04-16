
--  Copyright 2012 Stanislav Senotrusov <stan@senotrusov.com>
--
--  Licensed under the Apache License, Version 2.0 (the "License");
--  you may not use this file except in compliance with the License.
--  You may obtain a copy of the License at
--
--      http://www.apache.org/licenses/LICENSE-2.0
--
--  Unless required by applicable law or agreed to in writing, software
--  distributed under the License is distributed on an "AS IS" BASIS,
--  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--  See the License for the specific language governing permissions and
--  limitations under the License.


-- NOTE: We are using 'character varying' type instead of 'text', because TOAST (The Oversized-Attribute Storage Technique)
-- without proper control may fill in a lot of storage space.

BEGIN;

CREATE TABLE users (
  id                     bigserial PRIMARY KEY,
  created_at             timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at             timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  
  creator_addr           inet NOT NULL DEFAULT '127.0.0.1',
  
  email                  character varying(255),
  password               character varying(255),
  
  reset_password_token   character varying(255),
  reset_password_sent_at timestamp with time zone,
  
  last_sign_in_at        timestamp with time zone,
  last_sign_in_addr      inet
);

CREATE UNIQUE INDEX users_email_idx ON users USING btree (email);



CREATE TABLE boards (
  id          bigserial PRIMARY KEY,
  created_at  timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,

  slug        character varying(64) NOT NULL
);

CREATE UNIQUE INDEX boards_slug_idx ON boards USING btree (slug);



CREATE TABLE documents (
  id          bigserial PRIMARY KEY,
  created_at  timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  
  board_id            bigint NOT NULL references boards(id),
  author_id           bigint NOT NULL references users(id),
  author_identity_id  bigint, -- references author_identities(id)
  author_addr         inet   NOT NULL DEFAULT '127.0.0.1',
  
  author_identity_counter integer NOT NULL default 0, -- gapless sequence: update w/lock set + 1

  image        character varying(128),
  title        character varying(256),
  url          character varying(2048),
  message      character varying(1024)
);

CREATE INDEX documents_board_id_idx  ON documents USING btree (board_id);
CREATE INDEX documents_author_id_idx ON documents USING btree (author_id);



CREATE TABLE author_identities (
  id           bigserial PRIMARY KEY,
  created_at   timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,

  user_id      bigint  NOT NULL references users(id),
  user_addr    inet    NOT NULL DEFAULT '127.0.0.1',
  document_id  bigint  NOT NULL references documents(id),
  identity     integer NOT NULL
);

CREATE INDEX        author_identities_user_id_idx ON author_identities USING btree (user_id);
CREATE UNIQUE INDEX author_identities_unique_idx  ON author_identities USING btree (document_id, identity);

ALTER TABLE documents ADD CONSTRAINT documents_author_identity_id_fk FOREIGN KEY (author_identity_id) REFERENCES author_identities(id);


-- That schema does not support section prototypes - every instance is equal.
-- Permalink points to id, resulting page shows id section entry and all other entries as related data.

CREATE TABLE sections (
  id           bigserial PRIMARY KEY,
  created_at   timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,

  document_id         bigint NOT NULL references documents(id),
  author_identity_id  bigint NOT NULL references author_identities(id),
  author_addr         inet   NOT NULL DEFAULT '127.0.0.1',
  line_id             bigint NOT NULL references sections(id),
  
  image        character varying(128),
  title        character varying(256) NOT NULL,
  
  is_public_writable      boolean NOT NULL DEFAULT true,
  is_contributor_writable boolean NOT NULL DEFAULT false,
  is_versioned            boolean NOT NULL DEFAULT false,
  is_sortable             boolean NOT NULL DEFAULT false,
  
  paragraphs          bigint [], -- paragraphs order
  section_version_id  bigint -- references section_versions(id)
);

CREATE INDEX sections_document_id_idx ON sections USING btree (document_id);



CREATE TABLE section_versions (
  id           bigserial PRIMARY KEY,
  created_at   timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  
  section_id          bigint NOT NULL references sections(id),
  author_identity_id  bigint NOT NULL references author_identities(id),
  author_addr         inet   NOT NULL DEFAULT '127.0.0.1',

  image        character varying(128),
  title        character varying(256) NOT NULL,

  paragraphs          bigint []
);

CREATE INDEX section_versions_section_id_idx ON section_versions USING btree (section_id);

ALTER TABLE sections ADD CONSTRAINT sections_section_version_id_fk FOREIGN KEY (section_version_id) REFERENCES section_versions(id);


-- That schema does not support paragraph prototypes - every instance is equal.
-- Permalink points to id, resulting page shows id paragraph entry and all other entries as related data.
-- Paragraphs are immutable.
 
CREATE TABLE paragraphs (
  id           bigserial PRIMARY KEY,
  created_at   timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,

  section_id          bigint NOT NULL references sections(id),
  author_identity_id  bigint NOT NULL references author_identities(id),
  author_addr         inet   NOT NULL DEFAULT '127.0.0.1',
  line_id             bigint NOT NULL references paragraphs(id),
  
  image        character varying(128),
  title        character varying(256),
  url          character varying(2048),
  message      character varying(1024)
);

CREATE INDEX paragraphs_section_id_idx          ON paragraphs USING btree (section_id);
CREATE INDEX paragraphs_line_id_idx             ON paragraphs USING btree (line_id);

COMMIT;
