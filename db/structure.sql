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
    slug character varying(64) NOT NULL,
    documents_count integer DEFAULT 0 NOT NULL
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
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    poster_id bigint NOT NULL,
    poster_identity_id bigint NOT NULL,
    poster_addr inet DEFAULT '127.0.0.1'::inet NOT NULL,
    image character varying(128),
    title character varying(256),
    url character varying(1024),
    message character varying(1024),
    sections_framing text,
    poster_identities_count integer DEFAULT 0 NOT NULL,
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
-- Name: paragraphs; Type: TABLE; Schema: public; Owner: march; Tablespace: 
--

CREATE TABLE paragraphs (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    poster_identity_id bigint NOT NULL,
    poster_identity_document_id bigint NOT NULL,
    poster_identity_document_board_slug text NOT NULL,
    poster_identity_identity integer NOT NULL,
    poster_addr inet DEFAULT '127.0.0.1'::inet NOT NULL,
    image character varying(128),
    title character varying(256),
    url character varying(1024),
    message character varying(1024),
    section_id bigint NOT NULL,
    line_id bigint
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
-- Name: poster_identities; Type: TABLE; Schema: public; Owner: march; Tablespace: 
--

CREATE TABLE poster_identities (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    poster_id bigint NOT NULL,
    poster_addr inet DEFAULT '127.0.0.1'::inet NOT NULL,
    document_id bigint NOT NULL,
    identity integer NOT NULL
);


ALTER TABLE public.poster_identities OWNER TO march;

--
-- Name: poster_identities_id_seq; Type: SEQUENCE; Schema: public; Owner: march
--

CREATE SEQUENCE poster_identities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.poster_identities_id_seq OWNER TO march;

--
-- Name: poster_identities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: march
--

ALTER SEQUENCE poster_identities_id_seq OWNED BY poster_identities.id;


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
    session_key character varying(64),
    documents_count integer DEFAULT 0 NOT NULL,
    poster_identities_count integer DEFAULT 0 NOT NULL
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
-- Name: section_versions; Type: TABLE; Schema: public; Owner: march; Tablespace: 
--

CREATE TABLE section_versions (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    poster_identity_id bigint NOT NULL,
    poster_identity_document_id bigint NOT NULL,
    poster_identity_identity integer NOT NULL,
    poster_addr inet DEFAULT '127.0.0.1'::inet NOT NULL,
    public_writable boolean DEFAULT true NOT NULL,
    contributor_writable boolean DEFAULT true NOT NULL,
    image character varying(128),
    title character varying(256) NOT NULL,
    paragraphs bigint[],
    paragraphs_count integer DEFAULT 0 NOT NULL,
    section_id bigint NOT NULL,
    version integer NOT NULL
);


ALTER TABLE public.section_versions OWNER TO march;

--
-- Name: section_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: march
--

CREATE SEQUENCE section_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.section_versions_id_seq OWNER TO march;

--
-- Name: section_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: march
--

ALTER SEQUENCE section_versions_id_seq OWNED BY section_versions.id;


--
-- Name: sections; Type: TABLE; Schema: public; Owner: march; Tablespace: 
--

CREATE TABLE sections (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    poster_identity_id bigint NOT NULL,
    poster_identity_document_id bigint NOT NULL,
    poster_identity_identity integer NOT NULL,
    poster_addr inet DEFAULT '127.0.0.1'::inet NOT NULL,
    public_writable boolean DEFAULT true NOT NULL,
    contributor_writable boolean DEFAULT true NOT NULL,
    image character varying(128),
    title character varying(256) NOT NULL,
    paragraphs_order text,
    paragraphs_count integer DEFAULT 0 NOT NULL,
    document_id bigint NOT NULL,
    line_id bigint
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

ALTER TABLE ONLY paragraphs ALTER COLUMN id SET DEFAULT nextval('paragraphs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: march
--

ALTER TABLE ONLY poster_identities ALTER COLUMN id SET DEFAULT nextval('poster_identities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: march
--

ALTER TABLE ONLY posters ALTER COLUMN id SET DEFAULT nextval('posters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: march
--

ALTER TABLE ONLY section_versions ALTER COLUMN id SET DEFAULT nextval('section_versions_id_seq'::regclass);


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
-- Name: paragraphs_pkey; Type: CONSTRAINT; Schema: public; Owner: march; Tablespace: 
--

ALTER TABLE ONLY paragraphs
    ADD CONSTRAINT paragraphs_pkey PRIMARY KEY (id);


--
-- Name: poster_identities_pkey; Type: CONSTRAINT; Schema: public; Owner: march; Tablespace: 
--

ALTER TABLE ONLY poster_identities
    ADD CONSTRAINT poster_identities_pkey PRIMARY KEY (id);


--
-- Name: posters_pkey; Type: CONSTRAINT; Schema: public; Owner: march; Tablespace: 
--

ALTER TABLE ONLY posters
    ADD CONSTRAINT posters_pkey PRIMARY KEY (id);


--
-- Name: section_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: march; Tablespace: 
--

ALTER TABLE ONLY section_versions
    ADD CONSTRAINT section_versions_pkey PRIMARY KEY (id);


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
-- Name: paragraphs_line_id_idx; Type: INDEX; Schema: public; Owner: march; Tablespace: 
--

CREATE INDEX paragraphs_line_id_idx ON paragraphs USING btree (line_id);


--
-- Name: paragraphs_section_id_idx; Type: INDEX; Schema: public; Owner: march; Tablespace: 
--

CREATE INDEX paragraphs_section_id_idx ON paragraphs USING btree (section_id);


--
-- Name: poster_identities_poster_id_idx; Type: INDEX; Schema: public; Owner: march; Tablespace: 
--

CREATE INDEX poster_identities_poster_id_idx ON poster_identities USING btree (poster_id);


--
-- Name: poster_identities_unique_idx; Type: INDEX; Schema: public; Owner: march; Tablespace: 
--

CREATE UNIQUE INDEX poster_identities_unique_idx ON poster_identities USING btree (document_id, identity);


--
-- Name: posters_email_idx; Type: INDEX; Schema: public; Owner: march; Tablespace: 
--

CREATE UNIQUE INDEX posters_email_idx ON posters USING btree (email);


--
-- Name: posters_session_key_idx; Type: INDEX; Schema: public; Owner: march; Tablespace: 
--

CREATE UNIQUE INDEX posters_session_key_idx ON posters USING btree (session_key);


--
-- Name: section_versions_unique_idx; Type: INDEX; Schema: public; Owner: march; Tablespace: 
--

CREATE UNIQUE INDEX section_versions_unique_idx ON section_versions USING btree (section_id, version);


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
-- Name: documents_poster_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY documents
    ADD CONSTRAINT documents_poster_id_fkey FOREIGN KEY (poster_id) REFERENCES posters(id);


--
-- Name: documents_poster_identity_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY documents
    ADD CONSTRAINT documents_poster_identity_id_fk FOREIGN KEY (poster_identity_id) REFERENCES poster_identities(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: paragraphs_line_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY paragraphs
    ADD CONSTRAINT paragraphs_line_id_fkey FOREIGN KEY (line_id) REFERENCES paragraphs(id);


--
-- Name: paragraphs_poster_identity_document_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY paragraphs
    ADD CONSTRAINT paragraphs_poster_identity_document_id_fkey FOREIGN KEY (poster_identity_document_id) REFERENCES documents(id);


--
-- Name: paragraphs_poster_identity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY paragraphs
    ADD CONSTRAINT paragraphs_poster_identity_id_fkey FOREIGN KEY (poster_identity_id) REFERENCES poster_identities(id);


--
-- Name: paragraphs_section_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY paragraphs
    ADD CONSTRAINT paragraphs_section_id_fkey FOREIGN KEY (section_id) REFERENCES sections(id);


--
-- Name: poster_identities_document_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY poster_identities
    ADD CONSTRAINT poster_identities_document_id_fkey FOREIGN KEY (document_id) REFERENCES documents(id);


--
-- Name: poster_identities_poster_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY poster_identities
    ADD CONSTRAINT poster_identities_poster_id_fkey FOREIGN KEY (poster_id) REFERENCES posters(id);


--
-- Name: section_versions_poster_identity_document_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY section_versions
    ADD CONSTRAINT section_versions_poster_identity_document_id_fkey FOREIGN KEY (poster_identity_document_id) REFERENCES documents(id);


--
-- Name: section_versions_poster_identity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY section_versions
    ADD CONSTRAINT section_versions_poster_identity_id_fkey FOREIGN KEY (poster_identity_id) REFERENCES poster_identities(id);


--
-- Name: section_versions_section_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY section_versions
    ADD CONSTRAINT section_versions_section_id_fkey FOREIGN KEY (section_id) REFERENCES sections(id);


--
-- Name: sections_document_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY sections
    ADD CONSTRAINT sections_document_id_fkey FOREIGN KEY (document_id) REFERENCES documents(id);


--
-- Name: sections_line_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY sections
    ADD CONSTRAINT sections_line_id_fkey FOREIGN KEY (line_id) REFERENCES sections(id);


--
-- Name: sections_poster_identity_document_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY sections
    ADD CONSTRAINT sections_poster_identity_document_id_fkey FOREIGN KEY (poster_identity_document_id) REFERENCES documents(id);


--
-- Name: sections_poster_identity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY sections
    ADD CONSTRAINT sections_poster_identity_id_fkey FOREIGN KEY (poster_identity_id) REFERENCES poster_identities(id);


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

