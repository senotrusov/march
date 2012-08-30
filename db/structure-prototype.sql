
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

CREATE TABLE posters (
  id bigserial PRIMARY KEY,

  created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,

  sign_up_addr inet NOT NULL DEFAULT '127.0.0.1',

  email    character varying(255),
  password character varying(255),

  reset_password_token   character varying(255),
  reset_password_sent_at timestamp with time zone,

  last_sign_in_at   timestamp with time zone,
  last_sign_in_addr inet,

  session_key character varying(64)
);

CREATE UNIQUE INDEX posters_email_idx ON posters USING btree (email);
CREATE UNIQUE INDEX posters_session_key_idx ON posters USING btree (session_key);



CREATE TABLE boards (
  id bigserial PRIMARY KEY,

  created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,

  slug character varying(64) NOT NULL
);

CREATE UNIQUE INDEX boards_slug_idx ON boards USING btree (slug);



CREATE TABLE documents (
  id bigserial PRIMARY KEY,

  poster_addr inet NOT NULL DEFAULT '127.0.0.1',

  created_at  timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,

  poster_id   bigint NOT NULL references posters(id),
  identity_id bigint NOT NULL,  -- references identities(id),

  image   character varying(128),
  title   character varying(256),
  url     character varying(1024),
  message character varying(1024),

  lat  double precision,
  lng  double precision,
  zoom smallint,

  sections_framing text, -- json
  identities_count integer NOT NULL default 1, -- gapless sequence: update w/lock set + 1

  board_id bigint NOT NULL references boards(id),

  deleted    boolean NOT NULL DEFAULT false,
  deleted_at timestamp with time zone
);

CREATE INDEX documents_board_id_idx  ON documents USING btree (board_id);
CREATE INDEX documents_poster_id_idx ON documents USING btree (poster_id);


CREATE TABLE identities (
  id bigserial PRIMARY KEY,

  poster_addr inet NOT NULL DEFAULT '127.0.0.1',

  created_at  timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,

  poster_id   bigint  NOT NULL references posters(id),
  document_id bigint  NOT NULL references documents(id),
  name        integer NOT NULL
);

CREATE INDEX        identities_poster_id_idx ON identities USING btree (poster_id);
CREATE UNIQUE INDEX identities_unique_idx    ON identities USING btree (document_id, name);

ALTER TABLE documents ADD CONSTRAINT documents_identity_id_fk FOREIGN KEY (identity_id) REFERENCES identities(id) DEFERRABLE INITIALLY DEFERRED;


-- That schema does not support section prototypes - every instance is equal.
-- Permalink points to id, resulting a page which shows section with that id and, as a related data, all other sections with a line_id = that id

CREATE TABLE sections (
  id bigserial PRIMARY KEY,

  poster_addr inet NOT NULL DEFAULT '127.0.0.1',

  created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,

  identity_id          bigint  NOT NULL references identities(id),
  identity_name        integer NOT NULL,                          -- redundant data
  identity_board_slug  text    NOT NULL,                          -- redundant data
  identity_document_id bigint  NOT NULL references documents(id), -- redundant data

  proto_created_at timestamp with time zone,
  proto_updated_at timestamp with time zone,

  proto_identity_id          bigint references identities(id),
  proto_identity_name        integer,                          -- redundant data
  proto_identity_board_slug  text,                             -- redundant data
  proto_identity_document_id bigint references documents(id), -- redundant data

  public_writable      boolean DEFAULT true NOT NULL,
  contributor_writable boolean DEFAULT true NOT NULL,

  image      character varying(128),
  title      character varying(256) NOT NULL,

  paragraphs_order text, -- json

  document_id bigint NOT NULL references documents(id),
  line_id     bigint references sections(id) -- if line_id IS NULL, then there are no other line elements expected to be there
);

CREATE INDEX sections_document_id_idx ON sections USING btree (document_id);
CREATE INDEX sections_line_id_idx     ON sections USING btree (line_id);


-- Permalink forms from paragraphs.id, resulting a page which shows paragraph with that id
-- Other paragraphs with a line_id = paragraphs.id shown as a related data
 
CREATE TABLE paragraphs (
  id bigserial PRIMARY KEY,

  poster_addr inet NOT NULL DEFAULT '127.0.0.1',
  
  created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,

  identity_id          bigint  NOT NULL references identities(id),
  identity_name        integer NOT NULL,                          -- redundant data
  identity_board_slug  text    NOT NULL,                          -- redundant data
  identity_document_id bigint  NOT NULL references documents(id), -- redundant data

  
  proto_created_at timestamp with time zone,
  proto_updated_at timestamp with time zone,

  proto_identity_id          bigint references identities(id),
  proto_identity_name        integer,                          -- redundant data
  proto_identity_board_slug  text,                             -- redundant data
  proto_identity_document_id bigint references documents(id), -- redundant data
  
  image   character varying(128),
  title   character varying(256),
  url     character varying(1024),
  message character varying(1024),

  lat  double precision,
  lng  double precision,
  zoom smallint,

  section_id bigint NOT NULL references sections(id),
  line_id    bigint references paragraphs(id) -- if line_id IS NULL, then there are no other line elements expected to be there
);

CREATE INDEX paragraphs_section_id_idx ON paragraphs USING btree (section_id);
CREATE INDEX paragraphs_line_id_idx    ON paragraphs USING btree (line_id);

COMMIT;
