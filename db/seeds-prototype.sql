
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

BEGIN;

-- INSERT INTO posters(id)
--      VALUES (1);


INSERT INTO boards(id, slug)
     VALUES (1, 'a');

INSERT INTO boards(id, slug)
     VALUES (2, 'b');

INSERT INTO boards(id, slug)
     VALUES (3, 'c');


-- INSERT INTO documents(id, poster_id, title, url, message, board_id)
--      VALUES (1, 1, 'First document', 'http://example.org/foo/', 'This is an example of an example in order to bring an example.', 1);


-- INSERT INTO poster_identities(id, poster_id, document_id, identity)
--      VALUES (1, 1, 1, 1);
     
-- UPDATE documents SET poster_identity_id = 1, poster_identities_count = 1 WHERE id = 1;


-- INSERT INTO sections(id, poster_identity_id, poster_identity_document_id, poster_identity, title, document_id, line_id)
--      VALUES (1, 1, 1, 1, 'Comments', 1, NULL);

-- INSERT INTO sections(id, poster_identity_id, poster_identity_document_id, poster_identity, title, document_id, line_id)
--      VALUES (2, 1, 1, 1, 'Comments 2', 1, 2);

-- INSERT INTO sections(id, poster_identity_id, poster_identity_document_id, poster_identity, title, document_id, line_id)
--      VALUES (3, 1, 1, 1, 'Comments 2 INSTANCE 2', 1, 2);


-- INSERT INTO paragraphs(id, poster_identity_id, poster_identity_document_id, poster_identity, message, section_id, line_id)
--      VALUES (1, 1, 1, 1, 'Hello 1', 1, 1);

-- INSERT INTO paragraphs(id, poster_identity_id, poster_identity_document_id, poster_identity, message, section_id, line_id)
--      VALUES (2, 1, 1, 1, 'Hello 1 instance 2', 1, 1);

-- INSERT INTO paragraphs(id, poster_identity_id, poster_identity_document_id, poster_identity, message, section_id, line_id)
--      VALUES (3, 1, 1, 1, 'Hello 1 instance 3', 1, 1);


-- INSERT INTO paragraphs(id, poster_identity_id, poster_identity_document_id, poster_identity, message, section_id, line_id)
--      VALUES (4, 1, 1, 1, 'Hello 2', 1, NULL);



-- INSERT INTO paragraphs(id, poster_identity_id, poster_identity_document_id, poster_identity, message, section_id, line_id)
--      VALUES (5, 1, 1, 1, 'Hello 3', 2, 5);

-- INSERT INTO paragraphs(id, poster_identity_id, poster_identity_document_id, poster_identity, message, section_id, line_id)
--      VALUES (6, 1, 1, 1, 'Hello 3 instance 2', 2, 5);

-- INSERT INTO paragraphs(id, poster_identity_id, poster_identity_document_id, poster_identity, message, section_id, line_id)
--      VALUES (7, 1, 1, 1, 'Hello 3 instance 3', 2, 5);


-- INSERT INTO paragraphs(id, poster_identity_id, poster_identity_document_id, poster_identity, message, section_id, line_id)
--      VALUES (8, 1, 1, 1, 'Hello 4', 2, NULL);


-- INSERT INTO paragraphs(id, poster_identity_id, poster_identity_document_id, poster_identity, message, section_id, line_id)
--      VALUES (9, 1, 1, 1, 'Hello 1 instance in another section', 2, 1);


-- UPDATE sections SET paragraphs_count = (SELECT count(paragraphs.id) FROM paragraphs WHERE paragraphs.section_id = sections.id);

COMMIT;
