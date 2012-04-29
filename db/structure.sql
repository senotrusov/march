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
-- Name: author_identities; Type: TABLE; Schema: public; Owner: march; Tablespace: 
--

CREATE TABLE author_identities (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    user_id bigint NOT NULL,
    user_addr inet DEFAULT '127.0.0.1'::inet NOT NULL,
    document_id bigint NOT NULL,
    identity integer NOT NULL
);


ALTER TABLE public.author_identities OWNER TO march;

--
-- Name: author_identities_id_seq; Type: SEQUENCE; Schema: public; Owner: march
--

CREATE SEQUENCE author_identities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.author_identities_id_seq OWNER TO march;

--
-- Name: author_identities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: march
--

ALTER SEQUENCE author_identities_id_seq OWNED BY author_identities.id;


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
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    board_id bigint NOT NULL,
    author_id bigint NOT NULL,
    author_identity_id bigint,
    author_addr inet DEFAULT '127.0.0.1'::inet NOT NULL,
    author_identity_counter integer DEFAULT 0 NOT NULL,
    image character varying(128),
    title character varying(256),
    url character varying(2048),
    message character varying(1024)
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
    section_id bigint NOT NULL,
    author_identity_id bigint NOT NULL,
    author_addr inet DEFAULT '127.0.0.1'::inet NOT NULL,
    line_id bigint NOT NULL,
    image character varying(128),
    title character varying(256),
    url character varying(2048),
    message character varying(1024)
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
-- Name: section_versions; Type: TABLE; Schema: public; Owner: march; Tablespace: 
--

CREATE TABLE section_versions (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    section_id bigint NOT NULL,
    author_identity_id bigint NOT NULL,
    author_addr inet DEFAULT '127.0.0.1'::inet NOT NULL,
    image character varying(128),
    title character varying(256) NOT NULL,
    paragraphs bigint[]
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
    document_id bigint NOT NULL,
    author_identity_id bigint NOT NULL,
    author_addr inet DEFAULT '127.0.0.1'::inet NOT NULL,
    line_id bigint NOT NULL,
    image character varying(128),
    title character varying(256) NOT NULL,
    is_public_writable boolean DEFAULT true NOT NULL,
    is_contributor_writable boolean DEFAULT false NOT NULL,
    is_versioned boolean DEFAULT false NOT NULL,
    is_sortable boolean DEFAULT false NOT NULL,
    paragraphs bigint[],
    section_version_id bigint
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
-- Name: users; Type: TABLE; Schema: public; Owner: march; Tablespace: 
--

CREATE TABLE users (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    creator_addr inet DEFAULT '127.0.0.1'::inet NOT NULL,
    email character varying(255),
    password character varying(255),
    reset_password_token character varying(255),
    reset_password_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    last_sign_in_addr inet
);


ALTER TABLE public.users OWNER TO march;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: march
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO march;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: march
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: march
--

ALTER TABLE ONLY author_identities ALTER COLUMN id SET DEFAULT nextval('author_identities_id_seq'::regclass);


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

ALTER TABLE ONLY section_versions ALTER COLUMN id SET DEFAULT nextval('section_versions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: march
--

ALTER TABLE ONLY sections ALTER COLUMN id SET DEFAULT nextval('sections_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: march
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: author_identities_pkey; Type: CONSTRAINT; Schema: public; Owner: march; Tablespace: 
--

ALTER TABLE ONLY author_identities
    ADD CONSTRAINT author_identities_pkey PRIMARY KEY (id);


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
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: march; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: author_identities_unique_idx; Type: INDEX; Schema: public; Owner: march; Tablespace: 
--

CREATE UNIQUE INDEX author_identities_unique_idx ON author_identities USING btree (document_id, identity);


--
-- Name: author_identities_user_id_idx; Type: INDEX; Schema: public; Owner: march; Tablespace: 
--

CREATE INDEX author_identities_user_id_idx ON author_identities USING btree (user_id);


--
-- Name: boards_slug_idx; Type: INDEX; Schema: public; Owner: march; Tablespace: 
--

CREATE UNIQUE INDEX boards_slug_idx ON boards USING btree (slug);


--
-- Name: documents_author_id_idx; Type: INDEX; Schema: public; Owner: march; Tablespace: 
--

CREATE INDEX documents_author_id_idx ON documents USING btree (author_id);


--
-- Name: documents_board_id_idx; Type: INDEX; Schema: public; Owner: march; Tablespace: 
--

CREATE INDEX documents_board_id_idx ON documents USING btree (board_id);


--
-- Name: paragraphs_line_id_idx; Type: INDEX; Schema: public; Owner: march; Tablespace: 
--

CREATE INDEX paragraphs_line_id_idx ON paragraphs USING btree (line_id);


--
-- Name: paragraphs_section_id_idx; Type: INDEX; Schema: public; Owner: march; Tablespace: 
--

CREATE INDEX paragraphs_section_id_idx ON paragraphs USING btree (section_id);


--
-- Name: section_versions_section_id_idx; Type: INDEX; Schema: public; Owner: march; Tablespace: 
--

CREATE INDEX section_versions_section_id_idx ON section_versions USING btree (section_id);


--
-- Name: sections_document_id_idx; Type: INDEX; Schema: public; Owner: march; Tablespace: 
--

CREATE INDEX sections_document_id_idx ON sections USING btree (document_id);


--
-- Name: users_email_idx; Type: INDEX; Schema: public; Owner: march; Tablespace: 
--

CREATE UNIQUE INDEX users_email_idx ON users USING btree (email);


--
-- Name: author_identities_document_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY author_identities
    ADD CONSTRAINT author_identities_document_id_fkey FOREIGN KEY (document_id) REFERENCES documents(id);


--
-- Name: author_identities_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY author_identities
    ADD CONSTRAINT author_identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: documents_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY documents
    ADD CONSTRAINT documents_author_id_fkey FOREIGN KEY (author_id) REFERENCES users(id);


--
-- Name: documents_author_identity_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY documents
    ADD CONSTRAINT documents_author_identity_id_fk FOREIGN KEY (author_identity_id) REFERENCES author_identities(id);


--
-- Name: documents_board_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY documents
    ADD CONSTRAINT documents_board_id_fkey FOREIGN KEY (board_id) REFERENCES boards(id);


--
-- Name: paragraphs_author_identity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY paragraphs
    ADD CONSTRAINT paragraphs_author_identity_id_fkey FOREIGN KEY (author_identity_id) REFERENCES author_identities(id);


--
-- Name: paragraphs_line_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY paragraphs
    ADD CONSTRAINT paragraphs_line_id_fkey FOREIGN KEY (line_id) REFERENCES paragraphs(id);


--
-- Name: paragraphs_section_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY paragraphs
    ADD CONSTRAINT paragraphs_section_id_fkey FOREIGN KEY (section_id) REFERENCES sections(id);


--
-- Name: section_versions_author_identity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY section_versions
    ADD CONSTRAINT section_versions_author_identity_id_fkey FOREIGN KEY (author_identity_id) REFERENCES author_identities(id);


--
-- Name: section_versions_section_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY section_versions
    ADD CONSTRAINT section_versions_section_id_fkey FOREIGN KEY (section_id) REFERENCES sections(id);


--
-- Name: sections_author_identity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY sections
    ADD CONSTRAINT sections_author_identity_id_fkey FOREIGN KEY (author_identity_id) REFERENCES author_identities(id);


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
-- Name: sections_section_version_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: march
--

ALTER TABLE ONLY sections
    ADD CONSTRAINT sections_section_version_id_fk FOREIGN KEY (section_version_id) REFERENCES section_versions(id);


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

