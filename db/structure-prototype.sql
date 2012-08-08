
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

  session_key character varying(64),

  documents_count         integer NOT NULL default 0,
  poster_identities_count integer NOT NULL default 0
);

CREATE UNIQUE INDEX posters_email_idx ON posters USING btree (email);
CREATE UNIQUE INDEX posters_session_key_idx ON posters USING btree (session_key);



CREATE TABLE boards (
  id bigserial PRIMARY KEY,

  created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,

  slug character varying(64) NOT NULL,

  documents_count integer NOT NULL default 0
);

CREATE UNIQUE INDEX boards_slug_idx ON boards USING btree (slug);



CREATE TABLE documents (
  id bigserial PRIMARY KEY,

  created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,

  poster_id          bigint NOT NULL references posters(id),
  poster_identity_id bigint NOT NULL,  -- references poster_identities(id),
  poster_addr        inet   NOT NULL DEFAULT '127.0.0.1',

  image   character varying(128),
  title   character varying(256),
  url     character varying(1024),
  message character varying(1024),

  sections_framing text,
  poster_identities_count integer NOT NULL default 0, -- gapless sequence: update w/lock set + 1

  board_id bigint NOT NULL references boards(id),

  deleted    boolean NOT NULL DEFAULT false,
  deleted_at timestamp with time zone
);

CREATE INDEX documents_board_id_idx  ON documents USING btree (board_id);
CREATE INDEX documents_poster_id_idx ON documents USING btree (poster_id);


CREATE TABLE poster_identities (
  id bigserial PRIMARY KEY,

  created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,

  poster_id   bigint  NOT NULL references posters(id),
  poster_addr inet    NOT NULL DEFAULT '127.0.0.1',
  document_id bigint  NOT NULL references documents(id),
  identity    integer NOT NULL
);

CREATE INDEX        poster_identities_poster_id_idx ON poster_identities USING btree (poster_id);
CREATE UNIQUE INDEX poster_identities_unique_idx    ON poster_identities USING btree (document_id, identity);

ALTER TABLE documents ADD CONSTRAINT documents_poster_identity_id_fk FOREIGN KEY (poster_identity_id) REFERENCES poster_identities(id) DEFERRABLE INITIALLY DEFERRED;


-- That schema does not support section prototypes - every instance is equal.
-- Permalink points to id, resulting a page which shows section with that id and, as a related data, all other sections with a line_id = that id

CREATE TABLE sections (
  id bigserial PRIMARY KEY,

  created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,

  poster_identity_id          bigint  NOT NULL references poster_identities(id),
  poster_identity_document_id bigint  NOT NULL references documents(id), -- redundant data
  poster_identity_identity    integer NOT NULL,                          -- redundant data
  poster_addr                 inet    NOT NULL DEFAULT '127.0.0.1',

  public_writable      boolean DEFAULT true NOT NULL,
  contributor_writable boolean DEFAULT true NOT NULL,

  image      character varying(128),
  title      character varying(256) NOT NULL,

  paragraphs_order text,
  paragraphs_count integer NOT NULL DEFAULT 0,

  document_id bigint NOT NULL references documents(id),
  line_id     bigint references sections(id) -- if line_id IS NULL, then there are no other line elements expected to be there
);

CREATE INDEX sections_document_id_idx ON sections USING btree (document_id);
CREATE INDEX sections_line_id_idx     ON sections USING btree (line_id);


-- Permalink forms from paragraphs.id, resulting a page which shows paragraph with that id
-- Other paragraphs with a line_id = paragraphs.id shown as a related data
 
CREATE TABLE paragraphs (
  id bigserial PRIMARY KEY,

  created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,

  poster_identity_id                  bigint  NOT NULL references poster_identities(id),
  poster_identity_document_id         bigint  NOT NULL references documents(id), -- redundant data
  poster_identity_document_board_slug text    NOT NULL,                          -- redundant data
  poster_identity_identity            integer NOT NULL,                          -- redundant data
  poster_addr                         inet    NOT NULL DEFAULT '127.0.0.1',
  
  image   character varying(128),
  title   character varying(256),
  url     character varying(1024),
  message character varying(1024),
  -- quote '[0,10], [20,25]'

  section_id bigint NOT NULL references sections(id),
  line_id    bigint references paragraphs(id) -- if line_id IS NULL, then there are no other line elements expected to be there
);

CREATE INDEX paragraphs_section_id_idx ON paragraphs USING btree (section_id);
CREATE INDEX paragraphs_line_id_idx    ON paragraphs USING btree (line_id);

COMMIT;
