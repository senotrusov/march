--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: boards; Type: TABLE; Schema: public; Owner: march; Tablespace: 
--

CREATE TABLE boards (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    slug character varying(64) NOT NULL
);


ALTER TABLE public.boards OWNER TO march;

--
-- Name: boards_id_seq; Type: SEQUENCE; Schema: public; Owner: march
--

CREATE SEQUENCE boards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.boards_id_seq OWNER TO march;

--
-- Name: boards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: march
--

ALTER SEQUENCE boards_id_seq OWNED BY boards.id;


--
-- Name: documents; Type: TABLE; Schema: public; Owner: march; Tablespace: 
--

CREATE TABLE documents (
    id bigint NOT NULL,
    poster_addr inet DEFAULT '127.0.0.1'::inet NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    poster_id bigint NOT NULL,
    identity_id bigint NOT NULL,
    image character varying(128),
    title character varying(256),
    url character varying(1024),
    message character varying(1024),
    lat double precision,
    lng double precision,
    zoom smallint,
    sections_framing text,
    identities_count integer DEFAULT 1 NOT NULL,
    board_id bigint NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.documents OWNER TO march;

--
-- Name: documents_id_seq; Type: SEQUENCE; Schema: public; Owner: march
--

CREATE SEQUENCE documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.documents_id_seq OWNER TO march;

--
-- Name: documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: march
--

ALTER SEQUENCE documents_id_seq OWNED BY documents.id;


--
-- Name: identities; Type: TABLE; Schema: public; Owner: march; Tablespace: 
--

CREATE TABLE identities (
    id bigint NOT NULL,
    poster_addr inet DEFAULT '127.0.0.1'::inet NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    poster_id bigint NOT NULL,
    document_id bigint NOT NULL,
    name integer NOT NULL
);


ALTER TABLE public.identities OWNER TO march;

--
-- Name: identities_id_seq; Type: SEQUENCE; Schema: public; Owner: march
--

CREATE SEQUENCE identities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.identities_id_seq OWNER TO march;

--
-- Name: identities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: march
--

ALTER SEQUENCE identities_id_seq OWNED BY identities.id;


--
-- Name: paragraphs; Type: TABLE; Schema: public; Owner: march; Tablespace: 
--

CREATE TABLE paragraphs (
    id bigint NOT NULL,
    poster_addr inet DEFAULT '127.0.0.1'::inet NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    identity_id bigint NOT NULL,
    identity_name integer NOT NULL,
    identity_board_slug character varying(64) NOT NULL,
    identity_document_id bigint NOT NULL,
    proto_created_at timestamp with time zone,
    proto_updated_at timestamp with time zone,
    proto_identity_id bigint,
    proto_identity_name integer,
    proto_identity_board_slug character varying(64),
    proto_identity_document_id bigint,
    image character varying(128),
    title character varying(256),
    url character varying(1024),
    message character varying(1024),
    lat double precision,
    lng double precision,
    zoom smallint,
    section_id bigint NOT NULL,
    line_id bigint,
    deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    deleted_by bigint
);


ALTER TABLE public.paragraphs OWNER TO march;

--
-- Name: paragraphs_id_seq; Type: SEQUENCE; Schema: public; Owner: march
--

CREATE SEQUENCE paragraphs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.paragraphs_id_seq OWNER TO march;

--
-- Name: paragraphs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: march
--

ALTER SEQUENCE paragraphs_id_seq OWNED BY paragraphs.id;


--
-- Name: posters; Type: TABLE; Schema: public; Owner: march; Tablespace: 
--

CREATE TABLE posters (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    sign_up_addr inet DEFAULT '127.0.0.1'::inet NOT NULL,
    email character varying(255),
    password character varying(255),
    reset_password_token character varying(255),
    reset_password_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    last_sign_in_addr inet,
    session_key character varying(64)
);


ALTER TABLE public.posters OWNER TO march;

--
-- Name: posters_id_seq; Type: SEQUENCE; Schema: public; Owner: march
--

CREATE SEQUENCE posters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.posters_id_seq OWNER TO march;

--
-- Name: posters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: march
--

ALTER SEQUENCE posters_id_seq OWNED BY posters.id;


--
-- Name: sections; Type: TABLE; Schema: public; Owner: march; Tablespace: 
--

CREATE TABLE sections (
    id bigint NOT NULL,
    poster_addr inet DEFAULT '127.0.0.1'::inet NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    identity_id bigint NOT NULL,
    identity_name integer NOT NULL,
    identity_board_slug character varying(64) NOT NULL,
    identity_document_id bigint NOT NULL,
    proto_created_at timestamp with time zone,
    proto_updated_at timestamp with time zone,
    proto_identity_id bigint,
    proto_identity_name integer,
    proto_identity_board_slug character varying(64),
    proto_identity_document_id bigint,
    writable_by character varying(64) DEFAULT 'public'::character varying NOT NULL,
    sort_by character varying(64) DEFAULT 'created_at'::character varying NOT NULL,
    image character varying(128),
    title character varying(256) NOT NULL,
    paragraphs_order text,
    document_id bigint NOT NULL,
    line_id bigint,
    deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.sections OWNER TO march;

--
-- Name: sections_id_seq; Type: SEQUENCE; Schema: public; Owner: march
--

CREATE SEQUENCE sections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sections_id_seq OWNER TO march;

--
-- Name: sections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: march
--

ALTER SEQUENCE sections_id_seq OWNED BY sections.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: march
--

ALTER TABLE ONLY boards ALTER COLUMN id SET DEFAULT nextval('boards_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: march
--

ALTER TABLE ONLY documents ALTER COLUMN id SET DEFAULT nextval('documents_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: march
--

ALTER TABLE ONLY identities ALTER COLUMN id SET DEFAULT nextval('identities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: march
--

ALTER TABLE ONLY paragraphs ALTER COLUMN id SET DEFAULT nextval('paragraphs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: march
--

ALTER TABLE ONLY posters ALTER COLUMN id SET DEFAULT nextval('posters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: march
--

ALTER TABLE ONLY sections ALTER COLUMN id SET DEFAULT nextval('sections_id_seq'::regclass);


--
-- Name: boards_pkey; Type: CONSTRAINT; Schema: public; Owner: march; Tablespace: 
--

ALTER TABLE ONLY boards
    ADD CONSTRAINT boards_pkey PRIMARY KEY (id);


--
-- Name: documents_pkey; Type: CONSTRAINT; Schema: public; Owner: march; Tablespace: 
--

ALTER TABLE ONLY documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- Name: identities_pkey; Type: CONSTRAINT; Schema: public; Owner: march; Tablespace: 
--

ALTER TABLE ONLY identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: paragraphs_pkey; Type: CONSTRAINT; Schema: public; Owner: march; Tablespace: 
--

ALTER TABLE ONLY paragraphs
    ADD CONSTRAINT paragraphs_pkey PRIMARY KEY (id);


--
-- Name: posters_pkey; Type: CONSTRAINT; Schema: public; Owner: march; Tablespace: 
--

ALTER TABLE ONLY posters
    ADD CONSTRAINT posters_pkey PRIMARY KEY (id);


--
-- Name: sections_pkey; Type: CONSTRAINT; Schema: public; Owner: march; Tablespace: 
--

ALTER TABLE ONLY sections
    ADD CONSTRAINT sections_pkey PRIMARY KEY (id);


--
-- Name: boards_slug_idx; Type: INDEX; Schema: public; Owner: march; Tablespace: 
--

CREATE UNIQUE INDEX boards_slug_idx ON boards USING btree (slug);


--
-- Name: documents_board_id_idx; Type: INDEX; Schema: public; Owner: march; Tablespace: 
--

CREATE INDEX documents_board_id_idx ON documents USING btree (board_id);


--
-- Name: documents_poster_id_idx; Type: INDEX; Schema: public; Owner: march; Tablespace: 
--

CREATE INDEX documents_poster_id_idx ON documents USING btree (poster_id);


--
-- Name: identities_poster_id_idx; Type: INDEX; Schema: public; Owner: march; Tablespace: 
--

CREATE INDEX identities_poster_id_idx ON identities USING btree (poster_id);


--
-- Name: identities_unique_idx; Type: INDEX; Schema: public; Owner: march; Tablespace: 
--

CREATE UNIQUE INDEX identities_unique_idx ON identities USING btree (document_id, name);


--
-- Name: paragraphs_line_id_idx; Type: INDEX; Schema: public; Owner: march; Tablespace: 
--

CREATE INDEX paragraphs_line_id_idx ON paragraphs USING btree (line_id);


--
-- Name: paragraphs_section_id_idx; Type: INDEX; Schema: public; Owner: march; Tablespace: 
--

CREATE INDEX paragraphs_section_id_idx ON paragraphs USING btree (section_id);


--
-- Name: posters_email_idx; Type: INDEX; Schema: public; Owner: march; Tablespace: 
--

CREATE UNIQUE INDEX posters_email_idx ON posters USING btree (email);


--
-- Name: posters_session_key_idx; Type: INDEX; Schema: public; Owner: march; Tablespace: 
--

CREATE UNIQUE INDEX posters_session_key_idx ON posters USING btree (session_key);


--
-- Name: sections_document_id_idx; Type: INDEX; Schema: public; Owner: march; Tablespace: 
--

CREATE INDEX sections_document_id_idx ON sections USING btree (document_id);


--
-- Name: sections_line_id_idx; Type: INDEX; Schema: public; Owner: march; Tablespace: 
--

CREATE INDEX sections_line_id_idx ON sections USING btree (line_id);


--
-- Name: documents_board_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY documents
    ADD CONSTRAINT documents_board_id_fkey FOREIGN KEY (board_id) REFERENCES boards(id);


--
-- Name: documents_identity_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY documents
    ADD CONSTRAINT documents_identity_id_fk FOREIGN KEY (identity_id) REFERENCES identities(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: documents_poster_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY documents
    ADD CONSTRAINT documents_poster_id_fkey FOREIGN KEY (poster_id) REFERENCES posters(id);


--
-- Name: identities_document_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY identities
    ADD CONSTRAINT identities_document_id_fkey FOREIGN KEY (document_id) REFERENCES documents(id);


--
-- Name: identities_poster_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY identities
    ADD CONSTRAINT identities_poster_id_fkey FOREIGN KEY (poster_id) REFERENCES posters(id);


--
-- Name: paragraphs_deleted_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY paragraphs
    ADD CONSTRAINT paragraphs_deleted_by_fkey FOREIGN KEY (deleted_by) REFERENCES identities(id);


--
-- Name: paragraphs_identity_document_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY paragraphs
    ADD CONSTRAINT paragraphs_identity_document_id_fkey FOREIGN KEY (identity_document_id) REFERENCES documents(id);


--
-- Name: paragraphs_identity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY paragraphs
    ADD CONSTRAINT paragraphs_identity_id_fkey FOREIGN KEY (identity_id) REFERENCES identities(id);


--
-- Name: paragraphs_line_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY paragraphs
    ADD CONSTRAINT paragraphs_line_id_fkey FOREIGN KEY (line_id) REFERENCES paragraphs(id);


--
-- Name: paragraphs_proto_identity_document_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY paragraphs
    ADD CONSTRAINT paragraphs_proto_identity_document_id_fkey FOREIGN KEY (proto_identity_document_id) REFERENCES documents(id);


--
-- Name: paragraphs_proto_identity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY paragraphs
    ADD CONSTRAINT paragraphs_proto_identity_id_fkey FOREIGN KEY (proto_identity_id) REFERENCES identities(id);


--
-- Name: paragraphs_section_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY paragraphs
    ADD CONSTRAINT paragraphs_section_id_fkey FOREIGN KEY (section_id) REFERENCES sections(id);


--
-- Name: sections_document_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY sections
    ADD CONSTRAINT sections_document_id_fkey FOREIGN KEY (document_id) REFERENCES documents(id);


--
-- Name: sections_identity_document_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY sections
    ADD CONSTRAINT sections_identity_document_id_fkey FOREIGN KEY (identity_document_id) REFERENCES documents(id);


--
-- Name: sections_identity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY sections
    ADD CONSTRAINT sections_identity_id_fkey FOREIGN KEY (identity_id) REFERENCES identities(id);


--
-- Name: sections_line_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY sections
    ADD CONSTRAINT sections_line_id_fkey FOREIGN KEY (line_id) REFERENCES sections(id);


--
-- Name: sections_proto_identity_document_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY sections
    ADD CONSTRAINT sections_proto_identity_document_id_fkey FOREIGN KEY (proto_identity_document_id) REFERENCES documents(id);


--
-- Name: sections_proto_identity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY sections
    ADD CONSTRAINT sections_proto_identity_id_fkey FOREIGN KEY (proto_identity_id) REFERENCES identities(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

