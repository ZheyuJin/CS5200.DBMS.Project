--
-- PostgreSQL database dump
--

-- Dumped from database version 9.1.11
-- Dumped by pg_dump version 9.1.11
-- Started on 2014-03-25 15:41:34

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 7 (class 2615 OID 19081)
-- Name: libdb; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA libdb;


ALTER SCHEMA libdb OWNER TO postgres;

SET search_path = libdb, pg_catalog;

--
-- TOC entry 205 (class 1255 OID 19320)
-- Dependencies: 580 7
-- Name: get_random_number(integer, integer); Type: FUNCTION; Schema: libdb; Owner: postgres
--

CREATE FUNCTION get_random_number(integer, integer) RETURNS integer
    LANGUAGE plpgsql STRICT
    AS $_$
DECLARE
    start_int ALIAS FOR $1;
    end_int ALIAS FOR $2;
BEGIN
    RETURN trunc(random() * (end_int-start_int) + start_int);
END;
$_$;


ALTER FUNCTION libdb.get_random_number(integer, integer) OWNER TO postgres;

--
-- TOC entry 204 (class 1255 OID 19324)
-- Dependencies: 7 580
-- Name: get_random_string(integer); Type: FUNCTION; Schema: libdb; Owner: postgres
--

CREATE FUNCTION get_random_string(length integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    possible_chars TEXT := '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    output TEXT := '';
    i INT4;
BEGIN

    FOR i IN 1..length LOOP
        output := output || substr(possible_chars, get_random_number(1, length(possible_chars)), 1);
    END LOOP;

    RETURN output;
END;
$$;


ALTER FUNCTION libdb.get_random_string(length integer) OWNER TO postgres;

--
-- TOC entry 207 (class 1255 OID 19323)
-- Dependencies: 580 7
-- Name: random_text_simple(integer); Type: FUNCTION; Schema: libdb; Owner: postgres
--

CREATE FUNCTION random_text_simple(length integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    possible_chars TEXT := '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    output TEXT := '';
    i INT4;
BEGIN

    FOR i IN 1..length LOOP
        output := output || substr(possible_chars, get_random_number(1, length(possible_chars)), 1);
    END LOOP;

    RETURN output;
END;
$$;


ALTER FUNCTION libdb.random_text_simple(length integer) OWNER TO postgres;

--
-- TOC entry 206 (class 1255 OID 19322)
-- Dependencies: 580 7
-- Name: random_text_simple_1(integer); Type: FUNCTION; Schema: libdb; Owner: postgres
--

CREATE FUNCTION random_text_simple_1(length integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    possible_chars TEXT := '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    output TEXT := '';
    i INT4;
BEGIN

    FOR i IN 1..length LOOP
        output := output || substr(possible_chars, random_range(1, length(possible_chars)), 1);
    END LOOP;

    RETURN output;
END;
$$;


ALTER FUNCTION libdb.random_text_simple_1(length integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 189 (class 1259 OID 19260)
-- Dependencies: 7
-- Name: author; Type: TABLE; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE TABLE author (
    id integer NOT NULL,
    firstname character varying(45) NOT NULL,
    lastname character varying(45) NOT NULL,
    middlename character varying(45)
)
WITH (fillfactor=80);


ALTER TABLE libdb.author OWNER TO postgres;

--
-- TOC entry 188 (class 1259 OID 19258)
-- Dependencies: 7 189
-- Name: author_id_seq; Type: SEQUENCE; Schema: libdb; Owner: postgres
--

CREATE SEQUENCE author_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE libdb.author_id_seq OWNER TO postgres;

--
-- TOC entry 2065 (class 0 OID 0)
-- Dependencies: 188
-- Name: author_id_seq; Type: SEQUENCE OWNED BY; Schema: libdb; Owner: postgres
--

ALTER SEQUENCE author_id_seq OWNED BY author.id;


--
-- TOC entry 190 (class 1259 OID 19266)
-- Dependencies: 7
-- Name: authorize; Type: TABLE; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE TABLE authorize (
    author_id integer NOT NULL,
    book_id integer NOT NULL
)
WITH (fillfactor=80);


ALTER TABLE libdb.authorize OWNER TO postgres;

--
-- TOC entry 181 (class 1259 OID 19183)
-- Dependencies: 7
-- Name: book; Type: TABLE; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE TABLE book (
    id integer NOT NULL,
    isbn character varying(14),
    title character varying(100),
    publisher_id integer,
    year date,
    pages smallint,
    price real,
    "desc" character varying(500),
    sub_category_id integer,
    copy_count smallint
)
WITH (fillfactor=70);


ALTER TABLE libdb.book OWNER TO postgres;

--
-- TOC entry 187 (class 1259 OID 19240)
-- Dependencies: 7
-- Name: book_borrow; Type: TABLE; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE TABLE book_borrow (
    id integer NOT NULL,
    user_id integer NOT NULL,
    book_copy_id integer NOT NULL,
    borrow_date date NOT NULL,
    return_date_expected date NOT NULL,
    return_date_actual date
)
WITH (fillfactor=70);


ALTER TABLE libdb.book_borrow OWNER TO postgres;

--
-- TOC entry 186 (class 1259 OID 19238)
-- Dependencies: 187 7
-- Name: book_borrow_id_seq; Type: SEQUENCE; Schema: libdb; Owner: postgres
--

CREATE SEQUENCE book_borrow_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE libdb.book_borrow_id_seq OWNER TO postgres;

--
-- TOC entry 2066 (class 0 OID 0)
-- Dependencies: 186
-- Name: book_borrow_id_seq; Type: SEQUENCE OWNED BY; Schema: libdb; Owner: postgres
--

ALTER SEQUENCE book_borrow_id_seq OWNED BY book_borrow.id;


--
-- TOC entry 183 (class 1259 OID 19206)
-- Dependencies: 7
-- Name: book_copy; Type: TABLE; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE TABLE book_copy (
    id integer NOT NULL,
    book_id integer,
    status smallint,
    bookshelf_id integer
)
WITH (fillfactor=60);


ALTER TABLE libdb.book_copy OWNER TO postgres;

--
-- TOC entry 182 (class 1259 OID 19204)
-- Dependencies: 183 7
-- Name: book_copy_id_seq; Type: SEQUENCE; Schema: libdb; Owner: postgres
--

CREATE SEQUENCE book_copy_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE libdb.book_copy_id_seq OWNER TO postgres;

--
-- TOC entry 2067 (class 0 OID 0)
-- Dependencies: 182
-- Name: book_copy_id_seq; Type: SEQUENCE OWNED BY; Schema: libdb; Owner: postgres
--

ALTER SEQUENCE book_copy_id_seq OWNED BY book_copy.id;


--
-- TOC entry 180 (class 1259 OID 19181)
-- Dependencies: 7 181
-- Name: book_id_seq; Type: SEQUENCE; Schema: libdb; Owner: postgres
--

CREATE SEQUENCE book_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE libdb.book_id_seq OWNER TO postgres;

--
-- TOC entry 2068 (class 0 OID 0)
-- Dependencies: 180
-- Name: book_id_seq; Type: SEQUENCE OWNED BY; Schema: libdb; Owner: postgres
--

ALTER SEQUENCE book_id_seq OWNED BY book.id;


--
-- TOC entry 173 (class 1259 OID 19139)
-- Dependencies: 7
-- Name: bookshelf; Type: TABLE; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE TABLE bookshelf (
    id integer NOT NULL,
    label character varying(45),
    location_id integer NOT NULL
)
WITH (fillfactor=80);


ALTER TABLE libdb.bookshelf OWNER TO postgres;

--
-- TOC entry 172 (class 1259 OID 19137)
-- Dependencies: 7 173
-- Name: bookshelf_id_seq; Type: SEQUENCE; Schema: libdb; Owner: postgres
--

CREATE SEQUENCE bookshelf_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE libdb.bookshelf_id_seq OWNER TO postgres;

--
-- TOC entry 2069 (class 0 OID 0)
-- Dependencies: 172
-- Name: bookshelf_id_seq; Type: SEQUENCE OWNED BY; Schema: libdb; Owner: postgres
--

ALTER SEQUENCE bookshelf_id_seq OWNED BY bookshelf.id;


--
-- TOC entry 169 (class 1259 OID 19117)
-- Dependencies: 7
-- Name: building; Type: TABLE; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE TABLE building (
    id integer NOT NULL,
    name character varying(80) NOT NULL,
    address character varying(200) NOT NULL
)
WITH (fillfactor=90);


ALTER TABLE libdb.building OWNER TO postgres;

--
-- TOC entry 168 (class 1259 OID 19115)
-- Dependencies: 7 169
-- Name: building_id_seq; Type: SEQUENCE; Schema: libdb; Owner: postgres
--

CREATE SEQUENCE building_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE libdb.building_id_seq OWNER TO postgres;

--
-- TOC entry 2070 (class 0 OID 0)
-- Dependencies: 168
-- Name: building_id_seq; Type: SEQUENCE OWNED BY; Schema: libdb; Owner: postgres
--

ALTER SEQUENCE building_id_seq OWNED BY building.id;


--
-- TOC entry 163 (class 1259 OID 19084)
-- Dependencies: 7
-- Name: category; Type: TABLE; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE TABLE category (
    id integer NOT NULL,
    name character varying(100) NOT NULL
)
WITH (fillfactor=80);


ALTER TABLE libdb.category OWNER TO postgres;

--
-- TOC entry 162 (class 1259 OID 19082)
-- Dependencies: 163 7
-- Name: category_id_seq; Type: SEQUENCE; Schema: libdb; Owner: postgres
--

CREATE SEQUENCE category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE libdb.category_id_seq OWNER TO postgres;

--
-- TOC entry 2071 (class 0 OID 0)
-- Dependencies: 162
-- Name: category_id_seq; Type: SEQUENCE OWNED BY; Schema: libdb; Owner: postgres
--

ALTER SEQUENCE category_id_seq OWNED BY category.id;


--
-- TOC entry 171 (class 1259 OID 19125)
-- Dependencies: 7
-- Name: location; Type: TABLE; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE TABLE location (
    id integer NOT NULL,
    floor integer,
    building_id integer NOT NULL
)
WITH (fillfactor=90);


ALTER TABLE libdb.location OWNER TO postgres;

--
-- TOC entry 170 (class 1259 OID 19123)
-- Dependencies: 7 171
-- Name: location_id_seq; Type: SEQUENCE; Schema: libdb; Owner: postgres
--

CREATE SEQUENCE location_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE libdb.location_id_seq OWNER TO postgres;

--
-- TOC entry 2072 (class 0 OID 0)
-- Dependencies: 170
-- Name: location_id_seq; Type: SEQUENCE OWNED BY; Schema: libdb; Owner: postgres
--

ALTER SEQUENCE location_id_seq OWNED BY location.id;


--
-- TOC entry 175 (class 1259 OID 19153)
-- Dependencies: 7
-- Name: occupation; Type: TABLE; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE TABLE occupation (
    id integer NOT NULL,
    title character varying(45),
    borrow_limit smallint
)
WITH (fillfactor=80);


ALTER TABLE libdb.occupation OWNER TO postgres;

--
-- TOC entry 174 (class 1259 OID 19151)
-- Dependencies: 175 7
-- Name: occupation_id_seq; Type: SEQUENCE; Schema: libdb; Owner: postgres
--

CREATE SEQUENCE occupation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE libdb.occupation_id_seq OWNER TO postgres;

--
-- TOC entry 2073 (class 0 OID 0)
-- Dependencies: 174
-- Name: occupation_id_seq; Type: SEQUENCE OWNED BY; Schema: libdb; Owner: postgres
--

ALTER SEQUENCE occupation_id_seq OWNED BY occupation.id;


--
-- TOC entry 191 (class 1259 OID 19282)
-- Dependencies: 7
-- Name: penalty; Type: TABLE; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE TABLE penalty (
    user_id integer NOT NULL,
    issue_date date NOT NULL,
    clear_date date,
    amount real NOT NULL,
    book_borrow_id integer NOT NULL,
    penalty_reason_id integer NOT NULL
)
WITH (fillfactor=80);


ALTER TABLE libdb.penalty OWNER TO postgres;

--
-- TOC entry 177 (class 1259 OID 19161)
-- Dependencies: 7
-- Name: penalty_reason; Type: TABLE; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE TABLE penalty_reason (
    id integer NOT NULL,
    "desc" character varying(80) NOT NULL
)
WITH (fillfactor=90);


ALTER TABLE libdb.penalty_reason OWNER TO postgres;

--
-- TOC entry 176 (class 1259 OID 19159)
-- Dependencies: 177 7
-- Name: penalty_reason_id_seq; Type: SEQUENCE; Schema: libdb; Owner: postgres
--

CREATE SEQUENCE penalty_reason_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE libdb.penalty_reason_id_seq OWNER TO postgres;

--
-- TOC entry 2074 (class 0 OID 0)
-- Dependencies: 176
-- Name: penalty_reason_id_seq; Type: SEQUENCE OWNED BY; Schema: libdb; Owner: postgres
--

ALTER SEQUENCE penalty_reason_id_seq OWNED BY penalty_reason.id;


--
-- TOC entry 167 (class 1259 OID 19107)
-- Dependencies: 7
-- Name: publisher; Type: TABLE; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE TABLE publisher (
    id integer NOT NULL,
    name character varying(45) NOT NULL,
    email character varying(60),
    phone character varying(45)
)
WITH (fillfactor=80);


ALTER TABLE libdb.publisher OWNER TO postgres;

--
-- TOC entry 166 (class 1259 OID 19105)
-- Dependencies: 7 167
-- Name: publisher_id_seq; Type: SEQUENCE; Schema: libdb; Owner: postgres
--

CREATE SEQUENCE publisher_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE libdb.publisher_id_seq OWNER TO postgres;

--
-- TOC entry 2075 (class 0 OID 0)
-- Dependencies: 166
-- Name: publisher_id_seq; Type: SEQUENCE OWNED BY; Schema: libdb; Owner: postgres
--

ALTER SEQUENCE publisher_id_seq OWNED BY publisher.id;


--
-- TOC entry 165 (class 1259 OID 19093)
-- Dependencies: 7
-- Name: sub_category; Type: TABLE; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE TABLE sub_category (
    id integer NOT NULL,
    name character varying(100),
    category_id integer NOT NULL
)
WITH (fillfactor=80);


ALTER TABLE libdb.sub_category OWNER TO postgres;

--
-- TOC entry 164 (class 1259 OID 19091)
-- Dependencies: 7 165
-- Name: sub_category_id_seq; Type: SEQUENCE; Schema: libdb; Owner: postgres
--

CREATE SEQUENCE sub_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE libdb.sub_category_id_seq OWNER TO postgres;

--
-- TOC entry 2076 (class 0 OID 0)
-- Dependencies: 164
-- Name: sub_category_id_seq; Type: SEQUENCE OWNED BY; Schema: libdb; Owner: postgres
--

ALTER SEQUENCE sub_category_id_seq OWNED BY sub_category.id;


--
-- TOC entry 179 (class 1259 OID 19169)
-- Dependencies: 7
-- Name: user; Type: TABLE; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE TABLE "user" (
    id integer NOT NULL,
    lastname character varying(45) NOT NULL,
    firstname character varying(45) NOT NULL,
    middlename character varying(45),
    email character varying(60) NOT NULL,
    phone character varying(45),
    since date NOT NULL,
    occupation_id integer NOT NULL
)
WITH (fillfactor=70);


ALTER TABLE libdb."user" OWNER TO postgres;

--
-- TOC entry 178 (class 1259 OID 19167)
-- Dependencies: 179 7
-- Name: user_id_seq; Type: SEQUENCE; Schema: libdb; Owner: postgres
--

CREATE SEQUENCE user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE libdb.user_id_seq OWNER TO postgres;

--
-- TOC entry 2077 (class 0 OID 0)
-- Dependencies: 178
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: libdb; Owner: postgres
--

ALTER SEQUENCE user_id_seq OWNED BY "user".id;


--
-- TOC entry 185 (class 1259 OID 19226)
-- Dependencies: 7
-- Name: wishlist; Type: TABLE; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE TABLE wishlist (
    id integer NOT NULL,
    isbn character varying(14),
    request_date date,
    status smallint,
    user_id integer NOT NULL
)
WITH (fillfactor=70);


ALTER TABLE libdb.wishlist OWNER TO postgres;

--
-- TOC entry 184 (class 1259 OID 19224)
-- Dependencies: 185 7
-- Name: wishlist_id_seq; Type: SEQUENCE; Schema: libdb; Owner: postgres
--

CREATE SEQUENCE wishlist_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE libdb.wishlist_id_seq OWNER TO postgres;

--
-- TOC entry 2078 (class 0 OID 0)
-- Dependencies: 184
-- Name: wishlist_id_seq; Type: SEQUENCE OWNED BY; Schema: libdb; Owner: postgres
--

ALTER SEQUENCE wishlist_id_seq OWNED BY wishlist.id;


--
-- TOC entry 1852 (class 2604 OID 19263)
-- Dependencies: 188 189 189
-- Name: id; Type: DEFAULT; Schema: libdb; Owner: postgres
--

ALTER TABLE ONLY author ALTER COLUMN id SET DEFAULT nextval('author_id_seq'::regclass);


--
-- TOC entry 1848 (class 2604 OID 19186)
-- Dependencies: 181 180 181
-- Name: id; Type: DEFAULT; Schema: libdb; Owner: postgres
--

ALTER TABLE ONLY book ALTER COLUMN id SET DEFAULT nextval('book_id_seq'::regclass);


--
-- TOC entry 1851 (class 2604 OID 19243)
-- Dependencies: 187 186 187
-- Name: id; Type: DEFAULT; Schema: libdb; Owner: postgres
--

ALTER TABLE ONLY book_borrow ALTER COLUMN id SET DEFAULT nextval('book_borrow_id_seq'::regclass);


--
-- TOC entry 1849 (class 2604 OID 19209)
-- Dependencies: 182 183 183
-- Name: id; Type: DEFAULT; Schema: libdb; Owner: postgres
--

ALTER TABLE ONLY book_copy ALTER COLUMN id SET DEFAULT nextval('book_copy_id_seq'::regclass);


--
-- TOC entry 1844 (class 2604 OID 19142)
-- Dependencies: 173 172 173
-- Name: id; Type: DEFAULT; Schema: libdb; Owner: postgres
--

ALTER TABLE ONLY bookshelf ALTER COLUMN id SET DEFAULT nextval('bookshelf_id_seq'::regclass);


--
-- TOC entry 1842 (class 2604 OID 19120)
-- Dependencies: 169 168 169
-- Name: id; Type: DEFAULT; Schema: libdb; Owner: postgres
--

ALTER TABLE ONLY building ALTER COLUMN id SET DEFAULT nextval('building_id_seq'::regclass);


--
-- TOC entry 1839 (class 2604 OID 19087)
-- Dependencies: 162 163 163
-- Name: id; Type: DEFAULT; Schema: libdb; Owner: postgres
--

ALTER TABLE ONLY category ALTER COLUMN id SET DEFAULT nextval('category_id_seq'::regclass);


--
-- TOC entry 1843 (class 2604 OID 19128)
-- Dependencies: 170 171 171
-- Name: id; Type: DEFAULT; Schema: libdb; Owner: postgres
--

ALTER TABLE ONLY location ALTER COLUMN id SET DEFAULT nextval('location_id_seq'::regclass);


--
-- TOC entry 1845 (class 2604 OID 19156)
-- Dependencies: 174 175 175
-- Name: id; Type: DEFAULT; Schema: libdb; Owner: postgres
--

ALTER TABLE ONLY occupation ALTER COLUMN id SET DEFAULT nextval('occupation_id_seq'::regclass);


--
-- TOC entry 1846 (class 2604 OID 19164)
-- Dependencies: 177 176 177
-- Name: id; Type: DEFAULT; Schema: libdb; Owner: postgres
--

ALTER TABLE ONLY penalty_reason ALTER COLUMN id SET DEFAULT nextval('penalty_reason_id_seq'::regclass);


--
-- TOC entry 1841 (class 2604 OID 19110)
-- Dependencies: 166 167 167
-- Name: id; Type: DEFAULT; Schema: libdb; Owner: postgres
--

ALTER TABLE ONLY publisher ALTER COLUMN id SET DEFAULT nextval('publisher_id_seq'::regclass);


--
-- TOC entry 1840 (class 2604 OID 19096)
-- Dependencies: 164 165 165
-- Name: id; Type: DEFAULT; Schema: libdb; Owner: postgres
--

ALTER TABLE ONLY sub_category ALTER COLUMN id SET DEFAULT nextval('sub_category_id_seq'::regclass);


--
-- TOC entry 1847 (class 2604 OID 19172)
-- Dependencies: 179 178 179
-- Name: id; Type: DEFAULT; Schema: libdb; Owner: postgres
--

ALTER TABLE ONLY "user" ALTER COLUMN id SET DEFAULT nextval('user_id_seq'::regclass);


--
-- TOC entry 1850 (class 2604 OID 19229)
-- Dependencies: 184 185 185
-- Name: id; Type: DEFAULT; Schema: libdb; Owner: postgres
--

ALTER TABLE ONLY wishlist ALTER COLUMN id SET DEFAULT nextval('wishlist_id_seq'::regclass);


--
-- TOC entry 2058 (class 0 OID 19260)
-- Dependencies: 189 2061
-- Data for Name: author; Type: TABLE DATA; Schema: libdb; Owner: postgres
--

INSERT INTO author (id, firstname, lastname, middlename) VALUES (1, 'Audrey', 'BROWN', 'Y');
INSERT INTO author (id, firstname, lastname, middlename) VALUES (2, 'Richard', 'MILLER', 'L');
INSERT INTO author (id, firstname, lastname, middlename) VALUES (3, 'Joseph', 'SOLOMON', 'B');
INSERT INTO author (id, firstname, lastname, middlename) VALUES (4, 'Ethan', 'HINES', 'Y');
INSERT INTO author (id, firstname, lastname, middlename) VALUES (5, 'Stephen', 'HOLLAND', 'I');
INSERT INTO author (id, firstname, lastname, middlename) VALUES (6, 'Emanuel', 'CHOI', 'G');
INSERT INTO author (id, firstname, lastname, middlename) VALUES (7, 'Nicholas', 'MORALES', '1');
INSERT INTO author (id, firstname, lastname, middlename) VALUES (8, 'Manuel', 'PENA', 'G');
INSERT INTO author (id, firstname, lastname, middlename) VALUES (9, 'Trevor', 'MCINTOSH', '0');


--
-- TOC entry 2079 (class 0 OID 0)
-- Dependencies: 188
-- Name: author_id_seq; Type: SEQUENCE SET; Schema: libdb; Owner: postgres
--

SELECT pg_catalog.setval('author_id_seq', 9, true);


--
-- TOC entry 2059 (class 0 OID 19266)
-- Dependencies: 190 2061
-- Data for Name: authorize; Type: TABLE DATA; Schema: libdb; Owner: postgres
--

INSERT INTO authorize (author_id, book_id) VALUES (1, 1);
INSERT INTO authorize (author_id, book_id) VALUES (2, 2);
INSERT INTO authorize (author_id, book_id) VALUES (3, 3);
INSERT INTO authorize (author_id, book_id) VALUES (4, 4);
INSERT INTO authorize (author_id, book_id) VALUES (5, 5);
INSERT INTO authorize (author_id, book_id) VALUES (6, 6);
INSERT INTO authorize (author_id, book_id) VALUES (7, 7);
INSERT INTO authorize (author_id, book_id) VALUES (8, 8);
INSERT INTO authorize (author_id, book_id) VALUES (9, 9);
INSERT INTO authorize (author_id, book_id) VALUES (1, 10);
INSERT INTO authorize (author_id, book_id) VALUES (2, 11);
INSERT INTO authorize (author_id, book_id) VALUES (3, 12);
INSERT INTO authorize (author_id, book_id) VALUES (4, 13);
INSERT INTO authorize (author_id, book_id) VALUES (5, 14);
INSERT INTO authorize (author_id, book_id) VALUES (6, 15);
INSERT INTO authorize (author_id, book_id) VALUES (7, 16);
INSERT INTO authorize (author_id, book_id) VALUES (8, 17);
INSERT INTO authorize (author_id, book_id) VALUES (9, 18);
INSERT INTO authorize (author_id, book_id) VALUES (1, 19);
INSERT INTO authorize (author_id, book_id) VALUES (2, 20);
INSERT INTO authorize (author_id, book_id) VALUES (3, 21);
INSERT INTO authorize (author_id, book_id) VALUES (4, 22);
INSERT INTO authorize (author_id, book_id) VALUES (5, 23);
INSERT INTO authorize (author_id, book_id) VALUES (6, 24);
INSERT INTO authorize (author_id, book_id) VALUES (7, 25);
INSERT INTO authorize (author_id, book_id) VALUES (8, 26);
INSERT INTO authorize (author_id, book_id) VALUES (9, 27);
INSERT INTO authorize (author_id, book_id) VALUES (1, 28);
INSERT INTO authorize (author_id, book_id) VALUES (2, 29);
INSERT INTO authorize (author_id, book_id) VALUES (3, 30);
INSERT INTO authorize (author_id, book_id) VALUES (4, 1);
INSERT INTO authorize (author_id, book_id) VALUES (5, 2);
INSERT INTO authorize (author_id, book_id) VALUES (6, 3);
INSERT INTO authorize (author_id, book_id) VALUES (7, 4);
INSERT INTO authorize (author_id, book_id) VALUES (8, 5);
INSERT INTO authorize (author_id, book_id) VALUES (9, 6);
INSERT INTO authorize (author_id, book_id) VALUES (1, 7);
INSERT INTO authorize (author_id, book_id) VALUES (2, 8);
INSERT INTO authorize (author_id, book_id) VALUES (3, 9);
INSERT INTO authorize (author_id, book_id) VALUES (4, 10);
INSERT INTO authorize (author_id, book_id) VALUES (5, 11);
INSERT INTO authorize (author_id, book_id) VALUES (6, 12);
INSERT INTO authorize (author_id, book_id) VALUES (7, 13);
INSERT INTO authorize (author_id, book_id) VALUES (8, 14);
INSERT INTO authorize (author_id, book_id) VALUES (9, 15);
INSERT INTO authorize (author_id, book_id) VALUES (1, 16);
INSERT INTO authorize (author_id, book_id) VALUES (2, 17);
INSERT INTO authorize (author_id, book_id) VALUES (3, 18);
INSERT INTO authorize (author_id, book_id) VALUES (4, 19);
INSERT INTO authorize (author_id, book_id) VALUES (5, 20);
INSERT INTO authorize (author_id, book_id) VALUES (6, 21);
INSERT INTO authorize (author_id, book_id) VALUES (7, 22);
INSERT INTO authorize (author_id, book_id) VALUES (8, 23);
INSERT INTO authorize (author_id, book_id) VALUES (9, 24);
INSERT INTO authorize (author_id, book_id) VALUES (1, 25);
INSERT INTO authorize (author_id, book_id) VALUES (2, 26);
INSERT INTO authorize (author_id, book_id) VALUES (3, 27);
INSERT INTO authorize (author_id, book_id) VALUES (4, 28);
INSERT INTO authorize (author_id, book_id) VALUES (5, 29);
INSERT INTO authorize (author_id, book_id) VALUES (6, 30);
INSERT INTO authorize (author_id, book_id) VALUES (7, 1);
INSERT INTO authorize (author_id, book_id) VALUES (8, 2);
INSERT INTO authorize (author_id, book_id) VALUES (9, 3);
INSERT INTO authorize (author_id, book_id) VALUES (1, 4);
INSERT INTO authorize (author_id, book_id) VALUES (2, 5);
INSERT INTO authorize (author_id, book_id) VALUES (3, 6);
INSERT INTO authorize (author_id, book_id) VALUES (4, 7);
INSERT INTO authorize (author_id, book_id) VALUES (5, 8);
INSERT INTO authorize (author_id, book_id) VALUES (6, 9);
INSERT INTO authorize (author_id, book_id) VALUES (7, 10);
INSERT INTO authorize (author_id, book_id) VALUES (8, 11);
INSERT INTO authorize (author_id, book_id) VALUES (9, 12);
INSERT INTO authorize (author_id, book_id) VALUES (1, 13);
INSERT INTO authorize (author_id, book_id) VALUES (2, 14);
INSERT INTO authorize (author_id, book_id) VALUES (3, 15);
INSERT INTO authorize (author_id, book_id) VALUES (4, 16);
INSERT INTO authorize (author_id, book_id) VALUES (5, 17);
INSERT INTO authorize (author_id, book_id) VALUES (6, 18);
INSERT INTO authorize (author_id, book_id) VALUES (7, 19);
INSERT INTO authorize (author_id, book_id) VALUES (8, 20);
INSERT INTO authorize (author_id, book_id) VALUES (9, 21);
INSERT INTO authorize (author_id, book_id) VALUES (1, 22);
INSERT INTO authorize (author_id, book_id) VALUES (2, 23);
INSERT INTO authorize (author_id, book_id) VALUES (3, 24);
INSERT INTO authorize (author_id, book_id) VALUES (4, 25);
INSERT INTO authorize (author_id, book_id) VALUES (5, 26);
INSERT INTO authorize (author_id, book_id) VALUES (6, 27);
INSERT INTO authorize (author_id, book_id) VALUES (7, 28);
INSERT INTO authorize (author_id, book_id) VALUES (8, 29);
INSERT INTO authorize (author_id, book_id) VALUES (9, 30);


--
-- TOC entry 2050 (class 0 OID 19183)
-- Dependencies: 181 2061
-- Data for Name: book; Type: TABLE DATA; Schema: libdb; Owner: postgres
--

INSERT INTO book (id, isbn, title, publisher_id, year, pages, price, "desc", sub_category_id, copy_count) VALUES (1, 'A1X0ITY0KHIQTK', 'C3 MYQGTJF', 3, '2000-10-08', 110, 79, '85LRPOUOUOU3RKA3ODJ8YJ3VLO6M2V5U9HSAPU2P65N1KBYGB3IP0SYE4IUL877PYNPH0F077CCKOEXGY1TX0POOFTM0HG8E5POLUN81JQK9BP31QIGCLA3KEWSVE1DN6BDDXTE2L2R7AB6LNJ2ERPPLLDNC9GT6B2TE7T7W8HGDDA4V3ALN27HNYFBUS7IR60GEQIOXSVWSPFV2CH5B', 2, 5);
INSERT INTO book (id, isbn, title, publisher_id, year, pages, price, "desc", sub_category_id, copy_count) VALUES (2, 'D0YANCXAICLP4D', 'RX 0KU5EY5', 4, '2011-09-11', 161, 68, 'C9S45VSN0SH1D0RSRDV7O1AOT5CB5XFBHO1OB0QQ8Q18SG14CTR7396RK0JYYXLRJDHCNRLRWA4DCRULOTITMR3TAT1KSWIBCY6NLAXJJ8EWSROFM9YE7ABV3EGHY1OLCNA0LE96A3QIW3DAR9GJF9W5K69DJSRK89QSUMLRWKCDNTYBRHBP2IKEBM6XOADERYG4UH4UFQJGDQNCAYW4TTAY11YJB91296E9EXTOOMVNF5WVDL73J', 5, 5);
INSERT INTO book (id, isbn, title, publisher_id, year, pages, price, "desc", sub_category_id, copy_count) VALUES (3, 'XDG2G8FV1TMWL0', '5P DGV6OQQ', 2, '2012-06-18', 113, 32, 'QBI6X9X8CLGSC3FJSWWP3CUW2DUOYXXWN7HMBGD3R6J6HFRRXX94XBE0AVXXNY3DF4KWX15YIO1J9WKAHB3QUTJVO49JVAFV4VS8PHGURLEHRI1HLWBXRID9T1HXANRB941GD4J', 39, 5);
INSERT INTO book (id, isbn, title, publisher_id, year, pages, price, "desc", sub_category_id, copy_count) VALUES (4, 'SVU15WLTWKNWCF', '8U 8BOT25K', 5, '2013-01-20', 168, 84, '8C54YQ12BAW8DYHH7FBCJV3UW6VPO72XU83FVOJ9WO9DLOQBP7Q2XACV060P9NQ1K267QSR9180RFIWIPBS1BYTXHLCA9P1RV4W6OTX4YSQTP37QCUUQDKBM0H9HULNKI8MGKW942S7MKXP', 47, 5);
INSERT INTO book (id, isbn, title, publisher_id, year, pages, price, "desc", sub_category_id, copy_count) VALUES (5, 'Y9G0O0I7HCXMAH', 'UY Q0O8U4M', 9, '2008-11-12', 131, 91, 'SGL8ENXTUIC78U6L6AEW4HRQH9PYH8KWKMJGVDFE5MYHAKFA6B04GGCG7TSA8WEGPM2XOV2PL171VJJ2D34SEHEFSBEIER4UT13R66VRLA59A0TEWV3F3AY4S8EBF9HS31IEPAW7QMXUQWVOKSLQB0D83PC1605H560P1ATAAGU4TOR5LFC06SW2R5HRIBLKJ5EQ4SMSTWK4UKPT7S9CR9DSEV8Q3JJ9152N1DAXN5D5ODEUJ7WGL96C06TVV8HSO89D2R89CV4SKQSKHA864JY7PBTR1UIFW7JCI8LGTFQTKWA4FUNPMO7P9SQ28EKQ1HP', 1, 5);
INSERT INTO book (id, isbn, title, publisher_id, year, pages, price, "desc", sub_category_id, copy_count) VALUES (6, '97PDTYM7QTRTC1', 'JL R0VNQUB', 8, '2005-08-01', 152, 66, 'WQWMSD0XXIN14WP4N5Y53PLQMX7Y6LIK78WJX7AYUYQ29753E1TX4XGSTG3SIFQQKVJV4IH85WICUT3K6W6QV2EX1P73AKV2IGXO9UP7IG74PAA4BQ34LYHY6WMRXMQC504IFNT6FTOJPWSC9ARTUOF92EE35VFGNMHGSA6147VOHXT2FFT27Q', 19, 5);
INSERT INTO book (id, isbn, title, publisher_id, year, pages, price, "desc", sub_category_id, copy_count) VALUES (7, 'NB1W5H419SMOLM', '41 B3V4GLY', 2, '2001-12-05', 192, 34, 'UTU2S6PWQTQ6WSP22GY5304XLW1CPGM9W1QUJV3RG4YFNGQN352VT321W5VQI480FNWUSWCG5LF6VQH23I5MJRB8CR543K4148IKHLBMMKRLGH0FSH4QL1U070JN5M3LL1K3TNLNWRQ6SHYGWYUMMQCWI4UE9S1XS4VRSDVIEU86YW', 36, 5);
INSERT INTO book (id, isbn, title, publisher_id, year, pages, price, "desc", sub_category_id, copy_count) VALUES (8, 'M79DNN2RCE26I9', 'WF 4K3FR5B', 5, '2003-05-30', 186, 96, 'P9YBD64PVWIQHG5VNDL01LMLX0W1B523P8TSG0FGRU6XHB5QCXA1XEDNMLI2EUGYH21TAWFFS6U0U5HS9WK20JW9WGCC7QBAE9XPE6OYTOT4WETJTKDHL3C2RHXNPWYBUSQ74FI8NG1GSFPQDEK8L77EFNBFCWC9GNJ42C781KMS59MES7WA5XM7YPVUPIFWNNV2WWLP3B1PME3MY22OO80SWE1U1LPPEMKE92M453ET1W8M3PIYF3XY1E8HVBCRA8OPFU1WVDE443FDBVN730J4FFX8OQSEST0DIT7BVRJUAR9LBUXLVE4BFHBR4S1OYYRCB43GR0WNO9KH', 41, 5);
INSERT INTO book (id, isbn, title, publisher_id, year, pages, price, "desc", sub_category_id, copy_count) VALUES (9, '2WL1JAS3C9IKBV', 'B6 2IILUAO', 4, '2001-08-12', 142, 47, 'M2GCTLIGFB79MJTNMFOCKK2805CTF20PSNWPDIORTX5GL5QCEB49KDAIK2X9PA39YR0NR6ATSITBNRJKSYGBNNLHJVJS14RDVY7E4CDA2JNHTOU6T4PC6GUIUFMCT9Y9ES15TJWTSF5KQBHDBS30WO0O925VQ34FUWNO3CVFHVOBILUTSV427SYK4D6DRMBYNBK3D2B65C', 41, 5);
INSERT INTO book (id, isbn, title, publisher_id, year, pages, price, "desc", sub_category_id, copy_count) VALUES (10, 'QBX6T354795RT2', '5M P0FMFY7', 1, '2008-04-10', 100, 22, '9E49QRT4AVOP50242X6HF0CFHFAUF7V2E6I6CY9H1X0TSBU0K8IDILA96PEH8T4AJ6P9OFK3FAFKUGJWHODFR2UY7PB08JSA1XMDNLAMS25PN6C0MWQKK2XOC3O8MUUBQQJMYDE30AH37U7TRRIXYU6D9HCFGO1040N291DVEH5BNEN4OS8426EVECSE9JLUVHD7B7VJR0CTR341LJI26F0E19Y7YDIHS6PXLH8455Y319BMBU02UNA1RU89O', 64, 5);
INSERT INTO book (id, isbn, title, publisher_id, year, pages, price, "desc", sub_category_id, copy_count) VALUES (11, '451WCCPV999ASS', 'KX 3K062ET', 7, '2007-03-10', 125, 92, 'ISQ4D1GJIM1TA0OOJUU9K5ALS1UC5DBCT68AP1S108R4B2536R8RIQB47UE0VMBWY1DXGWMURWRJB0C4Q7YR052GD3CBONXAFM0KL86OG4QEQRHQVVICHSBCLFHVJA4TK6V9GMS3Y7HC99Q7ICX85NHA4TVIJSIGXOCVHNMFMXDPJ7TX9JUVAVJFDJ78CM176JL', 6, 5);
INSERT INTO book (id, isbn, title, publisher_id, year, pages, price, "desc", sub_category_id, copy_count) VALUES (12, '0BR7G7TSCVIEAY', 'E3 JEYEWJ2', 5, '2011-12-05', 144, 14, 'IDGKAWF73B6IQKTILNHLT2Y7VBS13MGHA8KF5KU9O3DCGFL0SPKL2XKN6VUBX75L1M9SB76RQG3IF7POFVF6PVYB7CDFE5LS6TT418XSOJRGMM', 31, 5);
INSERT INTO book (id, isbn, title, publisher_id, year, pages, price, "desc", sub_category_id, copy_count) VALUES (13, 'CSI8EAEOS7M36O', '0N PVFGDIG', 7, '2013-03-01', 124, 65, 'BVALL5F2NBWAK8M2AN8NF4VEHSU2BVA740FSJFHIIE3L5PP3H9HKEX01T4M3U2PGR44H4NSPN2OKQRLDOEUHO483SVYX56XYMXAADITGM3KPFSIOYEY76TEPNBAXQG9Q0LCSMM1', 48, 5);
INSERT INTO book (id, isbn, title, publisher_id, year, pages, price, "desc", sub_category_id, copy_count) VALUES (14, 'K6X0K4QQWOY7VQ', 'PT GCW1G0U', 4, '2008-10-22', 126, 60, '8B9FLT0LXUHDJ1GL8AH2XGH6E4AJC7R6DN1HCJU11O4FL4FGL757VNQQO4EY8WBQJDC05EMRY0SVLLX8Q4UB5DUKVGV6QF1CWTAXARVPTXCJ3MPIDRH3CKGT06GUWTDJFSCXVLH5COKULOWWO0804RX0FWPQDWVGUKLB3NJ06PTG30F19EDR4BJ67V8FQ0HMIMAKJDNAEF2QS3CXKS0GFBRQEPUDE3GJUPHWDQLDQK19N6AK2HP2X3LKR616IUVJ0I6CHU8K10529OLIR26NYES3GM2S57Y7SOCJ89JP3IAR79EVJ3RXSRC65PQ0URX62LHLG36Q6QCV46RHTO8GOST109W1CLKK', 20, 5);
INSERT INTO book (id, isbn, title, publisher_id, year, pages, price, "desc", sub_category_id, copy_count) VALUES (15, '85LY74IV3PKYDJ', '4Y B77MQUO', 4, '2003-07-22', 115, 45, '2CKFUWOHOSLC1LM6JA661OUOVJHV9JKU1GOD1E5IPC8YA99R3YAWSOGR609R6PAFY7J99K79Q44L9SSL0PI12JNHPYIB5KHAIASKU9JESMT4D95NSB8AOIE4H8BBLMU21LY6P0LJBRMKV6E26SNLV4CNYD15604CBQ81XUQS35VHC41CPRGNPKE2YEVK3WP7OA2QTT0YPVBYN4CRISGEG58KBDG7CSNX2G81D1R11KHYW1DDOKMPJJ18S6VKR2967R1W5K7XCM36DD6AW2E0J5', 52, 5);
INSERT INTO book (id, isbn, title, publisher_id, year, pages, price, "desc", sub_category_id, copy_count) VALUES (16, 'FX8W3XDEXB4DRY', '6C VAWR3SG', 5, '2001-08-18', 167, 63, '4GE9Q4CWFYMGIMKU2KH2XPEH1K404ORXY4YANDHJ15HUW9VU7DBSXANIW6BFK4C5K33MOMM9MFCI48MGV1302QY05ONQSP3OWLLLDLSY6VBD8NWFF9OC87B1DBPBLV881OEQN6OY2T9A7322WEETN44I5A7J5SFA1S9H7C0A00WUF3E5316GY0UANKX0B6U2ADA1VP6ETJ9JYWBQ2NWTE5D6BUTMTC06NTQTFLK2WPPTRGHU0EAHTVUB6MJ0MURRRSBO8IEU2PRK987BFFI0JT1CKEX42DQTADYA6I0LD5EN4OUEDPDR7VHVDWRB32FKJY93PMUKQHTAFKKIHHPPAYHUHNN8OH77O3W51EVLXA56XM7NTYTMUPX93AD6XUCRMH618HFXEG9', 11, 5);
INSERT INTO book (id, isbn, title, publisher_id, year, pages, price, "desc", sub_category_id, copy_count) VALUES (17, 'P816FSCFPQPIRE', 'OX GIXCAGG', 5, '2002-09-20', 114, 86, 'T5RFSF67WNYYUY7G04A3JBL6KOIPBYEVBM4OJ0S2NO2SLH4WV3CHIW6CVQ1OQMXWG4JLQUIRXAPRLGROHB1B1WEF6IOMKIYNMAI5DD5', 32, 5);
INSERT INTO book (id, isbn, title, publisher_id, year, pages, price, "desc", sub_category_id, copy_count) VALUES (18, 'S8M1RNFFRHVF8Y', 'FH J6VMJNA', 2, '2005-11-28', 169, 90, 'B6EOSLTA7V1RJW1A8V51I5MRTK3N88IDKSTMMXYCL45EA23V5NPNRH5Y52TKE7LOIX2ICWCW4MFA3R9MQ7KAEAU73BAR5FG0MCTRMOSRML0TA2VYCCS4WNS7ITH5W55Y7DN6QH5W3XEGDG74FE4IMGLT8JYP5RDRNFBXEWDDPHPVG6LGT5T8TVYUKVJUSIBLPQIYBHSX4D0RXJ3212RQ3LE9CYTVGXRB55XQM1HE5', 57, 5);
INSERT INTO book (id, isbn, title, publisher_id, year, pages, price, "desc", sub_category_id, copy_count) VALUES (19, '173E7VH52TSTN8', 'MS 337C36L', 2, '2009-11-18', 136, 42, 'VYWB9HGY6X18TEKXL93KO20VKWRDFH63RWAN3VA6PJ0CWHQ3EBVV272RNSRJTDJC8KLWHI0UK5S68E56F1C9BTJ7ERRI4KCP4K49S6BH7825E9K', 64, 5);
INSERT INTO book (id, isbn, title, publisher_id, year, pages, price, "desc", sub_category_id, copy_count) VALUES (20, 'FR7F6CE2W1VQSU', 'CG J9E6YKN', 4, '2013-04-03', 117, 19, 'XGPO82AWPXDV1CCB50MBLNF6S77RQQ20LLTG0H7FCJ63XXT33IO0F9UFUO549UKQJIQDT8DJM21J329WLDEFDIW6BWNGOWQBGIOHY1N9B05TX8L6WJY6EB8VDL0655SXEQEACSWP7KJE542A3U7IWXPCMGA97U9MWY3BMKUTDP3HDXGPO8C2E12H5WMCLNDKNDPWX5P700K3TQ1RGLWQP58SFKRC8EF27L3FQ3KTMA7H826VN14AB703W01OH28VN39FBE016A24FJSVREGAUO1BOFQ29', 50, 5);
INSERT INTO book (id, isbn, title, publisher_id, year, pages, price, "desc", sub_category_id, copy_count) VALUES (21, 'BVBKNEWLYD7YVT', 'OQ LN8PJOW', 5, '2012-12-19', 190, 50, 'BYN8GEUMRFXFLLXL28I5YJJGLP2V2CPLGPUNXIYSF85X5PTYMV1DMM8WQF0JVYL6Y2IW1EHGEMT7B3E5RD176BCI5M3A99DD2L6BBKLD1RQHDHV666MA6YMW0BUSC5V5WKJK4SWWT5H2PABKWFFD71GA7N4J8YO9XDL5RFM4CF9D7R7Q4JEEJOAF3CSAGA0T5TEDB34DVS5R0DJ79T8VIMWVRKJG7IHMBP0BGR3PB9WUAXNFCLEDYY719E27JFRRD9XOFL4Y9M6888CVF', 47, 5);
INSERT INTO book (id, isbn, title, publisher_id, year, pages, price, "desc", sub_category_id, copy_count) VALUES (22, 'Q4WAPXNP1AD7NY', '70 UP1KFMR', 2, '2011-08-24', 188, 91, 'MO8BNQK2RKXH1QHMBI4JQLB69APXTVMS6X24YFKSDHLQR9AR6UHI09T5KRM9JY80WDPWBLD4JU6VJEHPHGYKOP3T5B6A57GUM8YH1I43MCIIWGMXVPAP6D0Q6X8VNGHWPJR0Y8JJYQYRLCPIGY2DYBDU70EV7CQWPRXIFK82IU68IUA6', 4, 5);
INSERT INTO book (id, isbn, title, publisher_id, year, pages, price, "desc", sub_category_id, copy_count) VALUES (23, 'GNW8H60CX6BNOO', 'J6 K139A5D', 7, '2011-01-09', 106, 13, '6Q4OPT48N519HP6JANB9AB4X7CSHN3VCLFNJIFWGC407L25OP49PCW2TVW0N1W7JPLL1G1VYLH9N42RWXRXLA9MI1GS1QG0BL7J44EB1UQE99RQQ8V86YL69BB83BXXBEMU6Q139ET99FCJ4QTKP7WIJ5JOFWQFVAAJS', 49, 5);
INSERT INTO book (id, isbn, title, publisher_id, year, pages, price, "desc", sub_category_id, copy_count) VALUES (24, 'KPUWJREFR2TKMP', 'MK M7MPUE0', 7, '2014-01-13', 149, 55, '5RA98MKT8P1FTVCDP28T3XD8VXNA3PWQ0IW00CMSYEQPVF78ONWBLRY4RXM91E3WRJY1XY4J8EJ33IMNIH224YYHU2O9BAM0JNTJGT1C828Y720CBL6RX37QR2MD4PB6MDB3AR4MIW79Y7D21J0QPMYBRY0HTCWIEMGDPCI3B8TR5CYLBKNHCQ8I7OR9P93G39FJJCIE895LVUJUG8S3JNVLAFCF7NS384RBW0SREISYYLRHPJVS3YAUAP', 48, 5);
INSERT INTO book (id, isbn, title, publisher_id, year, pages, price, "desc", sub_category_id, copy_count) VALUES (25, 'U42J6G80FJUWMB', '0T XC1O6AT', 4, '2001-08-04', 166, 17, '1N5PPMT8VOKEU586Y3B8QF81F1XXXNXLNRLDA5BXIDO7DKBSQ5LOTRGHRJ43DCC5SMLL7TL5OR7V2BTM5IOVNMP3MCG4CWF5OUS055DWJV0Y0BAUJIS38KTEG5QS17KIK8MJX3ONKDAUVEXHS5KA69BTT34O62QWX13XBAXPAAF8Y1CQWNJIPA2PGJYKXG14G4UQOQKLLTKIQNE7225Y8YONFLO288T2KPHNYUUY4T7Q287W1PXYMCLM7UMY6I06M0O8BNPCW46L5FAB6NH292XYWE3412RQTJX', 37, 5);
INSERT INTO book (id, isbn, title, publisher_id, year, pages, price, "desc", sub_category_id, copy_count) VALUES (26, 'QAMJJXXUL9SWKD', 'JP QM0RDS9', 6, '2008-01-31', 187, 71, 'RA72U34Q50E5SXTVP7K69DSLFDBRYT8SEHVLARPK4LCR1FVNHUX5VPTW3BKN20I447RPGVOFSH51VDGYN0AD9F6PPCIU5HJ0WQEUVRP2KTWTSAN9NVJ280QVE563AXPBMRE0TQKC7OFDHF3EUN1H0XTV4Y8703S9M58CKFWBCQ7CMYNR47I1BDWT3PGQJK3A9IRYUSWGINYAGQRTTI5QVEHE2M00FN7ENQF695', 6, 5);
INSERT INTO book (id, isbn, title, publisher_id, year, pages, price, "desc", sub_category_id, copy_count) VALUES (27, '14I7BP56LB985U', 'WK MMITQBN', 9, '2009-08-18', 172, 10, '7ELNV0TC0BXH4MH2J00WUMU7B60OW2MYYASL9WTVPHXEOQ0MUBXWKGA5DYUAMBU29F3Y1OA63MO9S449JPSH2GU32CUY2G2SH3SPV6G5WH5HAR35B2D9DEVFW10QN70EGD0851OO2E4GVGSTX85YWSD5Y8JIDSQ0', 27, 5);
INSERT INTO book (id, isbn, title, publisher_id, year, pages, price, "desc", sub_category_id, copy_count) VALUES (28, '9K1A85Y6GU7XPA', 'MO N8ABI5P', 9, '2005-10-07', 165, 89, 'N4QXPGA566F1YFEWQB10LDGY0LM2EF11DFAJNEG5YQOQR4CK73STCBQS21EO21DWSB6SWTSM2M8TVQ691MA0ROLT1MB4113X6TQ6392OTKRW2Y3WTNIDXHCWN4IY1YFNI2QNFUW127JBCCPQJV954A35DXQJI51P8KRQR8K1V0IF2PP7SWVQRQRIY7KXKC3EKJ2F5W98TXXUGY7A5NC01UHH67CL6A43MOCLKPSREBD8SEL5920Q1S5C9DDGLK3W2X3ATQ1CDYS39FG31LAW', 57, 5);
INSERT INTO book (id, isbn, title, publisher_id, year, pages, price, "desc", sub_category_id, copy_count) VALUES (29, '74TLC3KFGUIC1G', 'B2 GH0CY68', 1, '2004-12-14', 140, 99, '1F3B1IIH1BENDXUXC8XA9JM9KB1KL3VN02265B6HVEG60R2M8VT39CAIPUIQLI1FLNGFAW9HEQLR05M4GT24ISW8QU9AF9E32370OX64G1S7S7EJR2AHDD8NGBU55S9TEWPDBAQL7PLQHMTF2K5BBDX2WDIYF7DC0OAMH6EGLHS4VFBMCER1XE0R0H7RHIBYB67NAWHAKU0J4OL8DFGSKRAJ06JH8QC5KJTIFDJHUNJFV691A', 51, 5);
INSERT INTO book (id, isbn, title, publisher_id, year, pages, price, "desc", sub_category_id, copy_count) VALUES (30, 'IPPV914RPUWII8', '9F JYL4L5B', 7, '2001-04-25', 104, 48, 'CSNT98BO6SKWY4H65TXWREMF6S2GST675SL677YY8G1QV1SQJJWDKRVYM96WNV4CUHEUC6QR1YFXNQ19BRPHKRK7AHV3PSX5KB0OOIWQAD1SV3SWTE0WGF9IHJM7OTJACPBWTGJHRT8NBHAO1I11JIF9OBM8VFOR565RS5VVDM8KBCEJORKI7JY4KLV5W32S5GXM1QJELXLF5ARH0UBXBTWU2XBMUHY8Y4CQG6EE0CR41PQ0ELS7CI32COWD422V8UCUTCJG41BE0363WGW3PD09RR0WLPAUQDCC4QTNEW6LFMH4N9QCR7MDXXV2N8WME3X45HESJFRYKYA5VD56USA5ILAQCH7YN6FYCVVQV3Y6NT8T', 14, 5);


--
-- TOC entry 2056 (class 0 OID 19240)
-- Dependencies: 187 2061
-- Data for Name: book_borrow; Type: TABLE DATA; Schema: libdb; Owner: postgres
--

INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (123, 12, 509, '2013-05-17', '2013-06-16', '2013-06-15');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (124, 8, 515, '2013-08-17', '2013-09-16', '2013-09-19');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (125, 6, 449, '2013-12-16', '2014-01-15', '2014-01-07');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (126, 18, 443, '2013-08-27', '2013-09-26', '2013-09-20');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (127, 17, 426, '2013-09-07', '2013-10-07', '2013-10-04');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (128, 4, 457, '2013-07-30', '2013-08-29', '2013-08-29');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (129, 15, 410, '2013-05-24', '2013-06-23', '2013-07-02');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (130, 12, 437, '2013-05-03', '2013-06-02', '2013-06-03');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (131, 19, 443, '2013-10-21', '2013-11-20', '2013-11-21');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (132, 10, 504, '2013-06-16', '2013-07-16', '2013-07-10');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (133, 6, 435, '2013-09-27', '2013-10-27', '2013-10-26');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (134, 16, 509, '2014-02-26', '2014-03-28', '2014-04-04');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (135, 11, 535, '2013-08-12', '2013-09-11', '2013-09-06');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (136, 8, 491, '2013-05-03', '2013-06-02', '2013-06-09');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (137, 10, 470, '2013-11-30', '2013-12-30', '2013-12-25');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (138, 14, 484, '2013-04-02', '2013-05-02', '2013-05-06');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (139, 10, 400, '2013-06-07', '2013-07-07', '2013-07-04');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (140, 4, 522, '2013-11-17', '2013-12-17', '2013-12-17');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (141, 15, 406, '2014-03-08', '2014-04-07', '2014-04-08');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (142, 19, 404, '2013-11-07', '2013-12-07', '2013-12-05');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (143, 9, 496, '2014-03-01', '2014-03-31', '2014-03-25');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (144, 8, 426, '2013-03-11', '2013-04-10', '2013-04-19');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (145, 14, 540, '2013-07-06', '2013-08-05', '2013-08-13');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (146, 7, 445, '2014-02-27', '2014-03-29', '2014-04-03');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (147, 7, 476, '2013-12-09', '2014-01-08', '2014-01-09');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (148, 10, 459, '2014-01-27', '2014-02-26', '2014-02-23');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (149, 18, 439, '2013-12-15', '2014-01-14', '2014-01-12');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (150, 11, 457, '2013-03-15', '2013-04-14', '2013-04-12');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (151, 14, 513, '2013-12-19', '2014-01-18', '2014-01-22');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (152, 9, 528, '2013-07-23', '2013-08-22', '2013-08-29');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (93, 17, 529, '2013-05-25', '2013-06-24', '2013-07-03');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (94, 5, 509, '2013-10-02', '2013-11-01', '2013-10-23');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (95, 18, 545, '2014-01-07', '2014-02-06', '2014-02-05');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (96, 12, 438, '2013-04-15', '2013-05-15', '2013-05-17');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (97, 8, 414, '2013-03-13', '2013-04-12', '2013-04-06');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (98, 6, 453, '2013-04-20', '2013-05-20', '2013-05-29');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (99, 5, 426, '2013-07-31', '2013-08-30', '2013-08-27');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (100, 15, 488, '2013-07-04', '2013-08-03', '2013-08-06');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (101, 14, 414, '2013-06-21', '2013-07-21', '2013-07-14');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (102, 18, 400, '2013-05-16', '2013-06-15', '2013-06-10');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (103, 16, 491, '2013-11-08', '2013-12-08', '2013-12-10');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (104, 12, 482, '2013-06-26', '2013-07-26', '2013-07-21');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (105, 16, 424, '2014-02-02', '2014-03-04', '2014-03-05');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (106, 6, 483, '2013-08-15', '2013-09-14', '2013-09-22');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (107, 7, 496, '2013-05-25', '2013-06-24', '2013-06-29');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (108, 10, 439, '2014-02-21', '2014-03-23', '2014-03-30');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (109, 8, 543, '2013-10-30', '2013-11-29', '2013-11-29');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (110, 6, 400, '2013-08-24', '2013-09-23', '2013-09-14');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (111, 7, 406, '2013-04-28', '2013-05-28', '2013-06-02');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (112, 19, 455, '2013-09-12', '2013-10-12', '2013-10-05');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (113, 18, 492, '2014-01-24', '2014-02-23', '2014-02-27');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (114, 4, 411, '2014-01-03', '2014-02-02', '2014-02-11');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (115, 14, 540, '2013-07-12', '2013-08-11', '2013-08-11');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (116, 10, 436, '2013-07-13', '2013-08-12', '2013-08-18');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (117, 17, 474, '2013-05-30', '2013-06-29', '2013-07-02');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (118, 14, 458, '2013-08-13', '2013-09-12', '2013-09-08');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (119, 9, 484, '2013-12-17', '2014-01-16', '2014-01-10');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (120, 9, 429, '2013-09-07', '2013-10-07', '2013-10-06');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (121, 6, 460, '2013-03-31', '2013-04-30', '2013-05-05');
INSERT INTO book_borrow (id, user_id, book_copy_id, borrow_date, return_date_expected, return_date_actual) VALUES (122, 15, 524, '2013-10-02', '2013-11-01', '2013-11-04');


--
-- TOC entry 2080 (class 0 OID 0)
-- Dependencies: 186
-- Name: book_borrow_id_seq; Type: SEQUENCE SET; Schema: libdb; Owner: postgres
--

SELECT pg_catalog.setval('book_borrow_id_seq', 152, true);


--
-- TOC entry 2052 (class 0 OID 19206)
-- Dependencies: 183 2061
-- Data for Name: book_copy; Type: TABLE DATA; Schema: libdb; Owner: postgres
--

INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (399, 1, 1, 20001);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (400, 2, 1, 20002);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (401, 3, 1, 20003);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (402, 4, 1, 20004);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (403, 5, 1, 20005);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (404, 6, 1, 20006);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (405, 7, 1, 20007);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (406, 8, 1, 20008);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (407, 9, 1, 20009);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (408, 10, 1, 20010);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (409, 11, 1, 20001);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (410, 12, 1, 20002);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (411, 13, 1, 20003);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (412, 14, 1, 20004);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (413, 15, 1, 20005);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (414, 16, 1, 20006);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (415, 17, 1, 20007);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (416, 18, 1, 20008);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (417, 19, 1, 20009);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (418, 20, 1, 20010);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (419, 21, 1, 20001);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (420, 22, 1, 20002);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (421, 23, 1, 20003);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (422, 24, 1, 20004);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (423, 25, 1, 20005);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (424, 26, 1, 20006);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (425, 27, 1, 20007);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (426, 28, 1, 20008);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (427, 29, 1, 20009);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (428, 30, 1, 20010);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (429, 1, 1, 20001);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (430, 2, 1, 20002);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (431, 3, 1, 20003);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (432, 4, 1, 20004);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (433, 5, 1, 20005);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (434, 6, 1, 20006);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (435, 7, 1, 20007);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (436, 8, 1, 20008);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (437, 9, 1, 20009);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (438, 10, 1, 20010);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (439, 11, 1, 20001);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (440, 12, 1, 20002);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (441, 13, 1, 20003);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (442, 14, 1, 20004);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (443, 15, 1, 20005);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (444, 16, 1, 20006);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (445, 17, 1, 20007);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (446, 18, 1, 20008);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (447, 19, 1, 20009);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (448, 20, 1, 20010);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (449, 21, 1, 20001);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (450, 22, 1, 20002);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (451, 23, 1, 20003);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (452, 24, 1, 20004);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (453, 25, 1, 20005);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (454, 26, 1, 20006);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (455, 27, 1, 20007);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (456, 28, 1, 20008);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (457, 29, 1, 20009);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (458, 30, 1, 20010);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (459, 1, 1, 20001);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (460, 2, 1, 20002);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (461, 3, 1, 20003);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (462, 4, 1, 20004);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (463, 5, 1, 20005);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (464, 6, 1, 20006);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (465, 7, 1, 20007);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (466, 8, 1, 20008);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (467, 9, 1, 20009);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (468, 10, 1, 20010);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (469, 11, 1, 20001);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (470, 12, 1, 20002);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (471, 13, 1, 20003);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (472, 14, 1, 20004);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (473, 15, 1, 20005);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (474, 16, 1, 20006);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (475, 17, 1, 20007);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (476, 18, 1, 20008);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (477, 19, 1, 20009);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (478, 20, 1, 20010);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (479, 21, 1, 20001);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (480, 22, 1, 20002);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (481, 23, 1, 20003);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (482, 24, 1, 20004);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (483, 25, 1, 20005);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (484, 26, 1, 20006);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (485, 27, 1, 20007);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (486, 28, 1, 20008);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (487, 29, 1, 20009);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (488, 30, 1, 20010);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (489, 1, 1, 20001);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (490, 2, 1, 20002);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (491, 3, 1, 20003);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (492, 4, 1, 20004);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (493, 5, 1, 20005);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (494, 6, 1, 20006);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (495, 7, 1, 20007);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (496, 8, 1, 20008);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (497, 9, 1, 20009);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (498, 10, 1, 20010);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (499, 11, 1, 20001);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (500, 12, 1, 20002);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (501, 13, 1, 20003);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (502, 14, 1, 20004);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (503, 15, 1, 20005);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (504, 16, 1, 20006);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (505, 17, 1, 20007);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (506, 18, 1, 20008);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (507, 19, 1, 20009);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (508, 20, 1, 20010);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (509, 21, 1, 20001);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (510, 22, 1, 20002);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (511, 23, 1, 20003);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (512, 24, 1, 20004);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (513, 25, 1, 20005);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (514, 26, 1, 20006);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (515, 27, 1, 20007);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (516, 28, 1, 20008);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (517, 29, 1, 20009);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (518, 30, 1, 20010);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (519, 1, 1, 20001);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (520, 2, 1, 20002);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (521, 3, 1, 20003);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (522, 4, 1, 20004);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (523, 5, 1, 20005);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (524, 6, 1, 20006);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (525, 7, 1, 20007);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (526, 8, 1, 20008);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (527, 9, 1, 20009);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (528, 10, 1, 20010);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (529, 11, 1, 20001);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (530, 12, 1, 20002);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (531, 13, 1, 20003);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (532, 14, 1, 20004);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (533, 15, 1, 20005);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (534, 16, 1, 20006);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (535, 17, 1, 20007);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (536, 18, 1, 20008);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (537, 19, 1, 20009);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (538, 20, 1, 20010);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (539, 21, 1, 20001);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (540, 22, 1, 20002);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (541, 23, 1, 20003);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (542, 24, 1, 20004);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (543, 25, 1, 20005);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (544, 26, 1, 20006);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (545, 27, 1, 20007);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (546, 28, 1, 20008);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (547, 29, 1, 20009);
INSERT INTO book_copy (id, book_id, status, bookshelf_id) VALUES (548, 30, 1, 20010);


--
-- TOC entry 2081 (class 0 OID 0)
-- Dependencies: 182
-- Name: book_copy_id_seq; Type: SEQUENCE SET; Schema: libdb; Owner: postgres
--

SELECT pg_catalog.setval('book_copy_id_seq', 548, true);


--
-- TOC entry 2082 (class 0 OID 0)
-- Dependencies: 180
-- Name: book_id_seq; Type: SEQUENCE SET; Schema: libdb; Owner: postgres
--

SELECT pg_catalog.setval('book_id_seq', 30, true);


--
-- TOC entry 2042 (class 0 OID 19139)
-- Dependencies: 173 2061
-- Data for Name: bookshelf; Type: TABLE DATA; Schema: libdb; Owner: postgres
--

INSERT INTO bookshelf (id, label, location_id) VALUES (20001, 'label-DE405', 157);
INSERT INTO bookshelf (id, label, location_id) VALUES (20002, 'label-SSNHH', 189);
INSERT INTO bookshelf (id, label, location_id) VALUES (20003, 'label-13MQP', 181);
INSERT INTO bookshelf (id, label, location_id) VALUES (20004, 'label-YP6YY', 152);
INSERT INTO bookshelf (id, label, location_id) VALUES (20005, 'label-F6CX4', 107);
INSERT INTO bookshelf (id, label, location_id) VALUES (20006, 'label-IFSG7', 108);
INSERT INTO bookshelf (id, label, location_id) VALUES (20007, 'label-V9FNR', 128);
INSERT INTO bookshelf (id, label, location_id) VALUES (20008, 'label-BFPIH', 110);
INSERT INTO bookshelf (id, label, location_id) VALUES (20009, 'label-0P4LB', 106);
INSERT INTO bookshelf (id, label, location_id) VALUES (20010, 'label-H8BC3', 141);


--
-- TOC entry 2083 (class 0 OID 0)
-- Dependencies: 172
-- Name: bookshelf_id_seq; Type: SEQUENCE SET; Schema: libdb; Owner: postgres
--

SELECT pg_catalog.setval('bookshelf_id_seq', 20010, true);


--
-- TOC entry 2038 (class 0 OID 19117)
-- Dependencies: 169 2061
-- Data for Name: building; Type: TABLE DATA; Schema: libdb; Owner: postgres
--

INSERT INTO building (id, name, address) VALUES (23, 'West Village F', '40A Leon St');
INSERT INTO building (id, name, address) VALUES (24, 'Ryder Hall', '11 Leon St');
INSERT INTO building (id, name, address) VALUES (25, 'West Village G', '450 Parker St.');
INSERT INTO building (id, name, address) VALUES (26, 'Behrakis Health Sciences Center', '30 Leon St');
INSERT INTO building (id, name, address) VALUES (27, 'West Village H', '440 Huntington Ave.');
INSERT INTO building (id, name, address) VALUES (28, 'Shillman Hall ', '115 Forsyth St');
INSERT INTO building (id, name, address) VALUES (29, 'Richards Hall', '360 Huntington Ave');
INSERT INTO building (id, name, address) VALUES (30, 'Lake Hall', '43 Leon St');
INSERT INTO building (id, name, address) VALUES (31, 'Hurtig Hall', '334 Huntington Ave');
INSERT INTO building (id, name, address) VALUES (32, 'Mugar Life Sciences Building ', '330 Huntington Ave');
INSERT INTO building (id, name, address) VALUES (33, 'Ell Hall', '346 Huntington Ave');
INSERT INTO building (id, name, address) VALUES (34, 'Hayden Hall', '370 Huntington Ave.');
INSERT INTO building (id, name, address) VALUES (35, 'Snell Engineering Center', '110 Forsyth St');
INSERT INTO building (id, name, address) VALUES (36, 'Snell Library', '376 Huntington Ave');
INSERT INTO building (id, name, address) VALUES (37, 'Architecture Studio (AS)', 'Ruggles Center');
INSERT INTO building (id, name, address) VALUES (38, 'Badger-Rosen SquashBusters Center', '795 Columbus Ave.');
INSERT INTO building (id, name, address) VALUES (39, 'Asian-American Center (AC)', '109 Hemenway St');
INSERT INTO building (id, name, address) VALUES (40, 'International Village', '1155-75 Tremont St');
INSERT INTO building (id, name, address) VALUES (41, ' Light Hall', '81-83 St. Stephen St');
INSERT INTO building (id, name, address) VALUES (42, 'Kennedy Hall', '119 Hemenway St');


--
-- TOC entry 2084 (class 0 OID 0)
-- Dependencies: 168
-- Name: building_id_seq; Type: SEQUENCE SET; Schema: libdb; Owner: postgres
--

SELECT pg_catalog.setval('building_id_seq', 1, false);


--
-- TOC entry 2032 (class 0 OID 19084)
-- Dependencies: 163 2061
-- Data for Name: category; Type: TABLE DATA; Schema: libdb; Owner: postgres
--

INSERT INTO category (id, name) VALUES (2, 'Business/Technical');
INSERT INTO category (id, name) VALUES (3, 'Fiction');
INSERT INTO category (id, name) VALUES (4, 'Nonfiction');
INSERT INTO category (id, name) VALUES (5, 'Special Interest');
INSERT INTO category (id, name) VALUES (6, 'Young Readers');
INSERT INTO category (id, name) VALUES (7, 'Travel');


--
-- TOC entry 2085 (class 0 OID 0)
-- Dependencies: 162
-- Name: category_id_seq; Type: SEQUENCE SET; Schema: libdb; Owner: postgres
--

SELECT pg_catalog.setval('category_id_seq', 7, true);


--
-- TOC entry 2040 (class 0 OID 19125)
-- Dependencies: 171 2061
-- Data for Name: location; Type: TABLE DATA; Schema: libdb; Owner: postgres
--

INSERT INTO location (id, floor, building_id) VALUES (101, 2, 24);
INSERT INTO location (id, floor, building_id) VALUES (102, 2, 33);
INSERT INTO location (id, floor, building_id) VALUES (103, 3, 37);
INSERT INTO location (id, floor, building_id) VALUES (104, 1, 25);
INSERT INTO location (id, floor, building_id) VALUES (105, 2, 37);
INSERT INTO location (id, floor, building_id) VALUES (106, 1, 31);
INSERT INTO location (id, floor, building_id) VALUES (107, 2, 33);
INSERT INTO location (id, floor, building_id) VALUES (108, 1, 30);
INSERT INTO location (id, floor, building_id) VALUES (109, 2, 30);
INSERT INTO location (id, floor, building_id) VALUES (110, 3, 31);
INSERT INTO location (id, floor, building_id) VALUES (111, 1, 39);
INSERT INTO location (id, floor, building_id) VALUES (112, 1, 39);
INSERT INTO location (id, floor, building_id) VALUES (113, 2, 26);
INSERT INTO location (id, floor, building_id) VALUES (114, 2, 31);
INSERT INTO location (id, floor, building_id) VALUES (115, 2, 29);
INSERT INTO location (id, floor, building_id) VALUES (116, 3, 35);
INSERT INTO location (id, floor, building_id) VALUES (117, 2, 40);
INSERT INTO location (id, floor, building_id) VALUES (118, 3, 26);
INSERT INTO location (id, floor, building_id) VALUES (119, 3, 39);
INSERT INTO location (id, floor, building_id) VALUES (120, 2, 39);
INSERT INTO location (id, floor, building_id) VALUES (121, 2, 30);
INSERT INTO location (id, floor, building_id) VALUES (122, 2, 34);
INSERT INTO location (id, floor, building_id) VALUES (123, 3, 39);
INSERT INTO location (id, floor, building_id) VALUES (124, 3, 31);
INSERT INTO location (id, floor, building_id) VALUES (125, 3, 24);
INSERT INTO location (id, floor, building_id) VALUES (126, 2, 25);
INSERT INTO location (id, floor, building_id) VALUES (127, 3, 39);
INSERT INTO location (id, floor, building_id) VALUES (128, 1, 24);
INSERT INTO location (id, floor, building_id) VALUES (129, 1, 23);
INSERT INTO location (id, floor, building_id) VALUES (130, 3, 39);
INSERT INTO location (id, floor, building_id) VALUES (131, 1, 26);
INSERT INTO location (id, floor, building_id) VALUES (132, 2, 37);
INSERT INTO location (id, floor, building_id) VALUES (133, 1, 34);
INSERT INTO location (id, floor, building_id) VALUES (134, 3, 25);
INSERT INTO location (id, floor, building_id) VALUES (135, 3, 38);
INSERT INTO location (id, floor, building_id) VALUES (136, 3, 25);
INSERT INTO location (id, floor, building_id) VALUES (137, 2, 35);
INSERT INTO location (id, floor, building_id) VALUES (138, 3, 29);
INSERT INTO location (id, floor, building_id) VALUES (139, 1, 26);
INSERT INTO location (id, floor, building_id) VALUES (140, 3, 32);
INSERT INTO location (id, floor, building_id) VALUES (141, 3, 35);
INSERT INTO location (id, floor, building_id) VALUES (142, 2, 30);
INSERT INTO location (id, floor, building_id) VALUES (143, 2, 36);
INSERT INTO location (id, floor, building_id) VALUES (144, 3, 39);
INSERT INTO location (id, floor, building_id) VALUES (145, 3, 26);
INSERT INTO location (id, floor, building_id) VALUES (146, 2, 31);
INSERT INTO location (id, floor, building_id) VALUES (147, 1, 40);
INSERT INTO location (id, floor, building_id) VALUES (148, 2, 25);
INSERT INTO location (id, floor, building_id) VALUES (149, 2, 25);
INSERT INTO location (id, floor, building_id) VALUES (150, 2, 41);
INSERT INTO location (id, floor, building_id) VALUES (151, 3, 25);
INSERT INTO location (id, floor, building_id) VALUES (152, 2, 25);
INSERT INTO location (id, floor, building_id) VALUES (153, 1, 31);
INSERT INTO location (id, floor, building_id) VALUES (154, 1, 25);
INSERT INTO location (id, floor, building_id) VALUES (155, 2, 36);
INSERT INTO location (id, floor, building_id) VALUES (156, 1, 32);
INSERT INTO location (id, floor, building_id) VALUES (157, 3, 30);
INSERT INTO location (id, floor, building_id) VALUES (158, 1, 40);
INSERT INTO location (id, floor, building_id) VALUES (159, 1, 30);
INSERT INTO location (id, floor, building_id) VALUES (160, 2, 36);
INSERT INTO location (id, floor, building_id) VALUES (161, 1, 27);
INSERT INTO location (id, floor, building_id) VALUES (162, 3, 31);
INSERT INTO location (id, floor, building_id) VALUES (163, 2, 33);
INSERT INTO location (id, floor, building_id) VALUES (164, 3, 30);
INSERT INTO location (id, floor, building_id) VALUES (165, 3, 28);
INSERT INTO location (id, floor, building_id) VALUES (166, 1, 40);
INSERT INTO location (id, floor, building_id) VALUES (167, 3, 37);
INSERT INTO location (id, floor, building_id) VALUES (168, 3, 36);
INSERT INTO location (id, floor, building_id) VALUES (169, 1, 33);
INSERT INTO location (id, floor, building_id) VALUES (170, 2, 32);
INSERT INTO location (id, floor, building_id) VALUES (171, 3, 24);
INSERT INTO location (id, floor, building_id) VALUES (172, 1, 23);
INSERT INTO location (id, floor, building_id) VALUES (173, 2, 27);
INSERT INTO location (id, floor, building_id) VALUES (174, 2, 24);
INSERT INTO location (id, floor, building_id) VALUES (175, 1, 37);
INSERT INTO location (id, floor, building_id) VALUES (176, 2, 28);
INSERT INTO location (id, floor, building_id) VALUES (177, 2, 30);
INSERT INTO location (id, floor, building_id) VALUES (178, 3, 24);
INSERT INTO location (id, floor, building_id) VALUES (179, 3, 41);
INSERT INTO location (id, floor, building_id) VALUES (180, 2, 26);
INSERT INTO location (id, floor, building_id) VALUES (181, 1, 39);
INSERT INTO location (id, floor, building_id) VALUES (182, 3, 33);
INSERT INTO location (id, floor, building_id) VALUES (183, 2, 36);
INSERT INTO location (id, floor, building_id) VALUES (184, 2, 39);
INSERT INTO location (id, floor, building_id) VALUES (185, 2, 33);
INSERT INTO location (id, floor, building_id) VALUES (186, 2, 23);
INSERT INTO location (id, floor, building_id) VALUES (187, 1, 25);
INSERT INTO location (id, floor, building_id) VALUES (188, 3, 34);
INSERT INTO location (id, floor, building_id) VALUES (189, 2, 25);
INSERT INTO location (id, floor, building_id) VALUES (190, 1, 27);
INSERT INTO location (id, floor, building_id) VALUES (191, 1, 29);
INSERT INTO location (id, floor, building_id) VALUES (192, 3, 29);
INSERT INTO location (id, floor, building_id) VALUES (193, 1, 28);
INSERT INTO location (id, floor, building_id) VALUES (194, 3, 33);
INSERT INTO location (id, floor, building_id) VALUES (195, 3, 28);
INSERT INTO location (id, floor, building_id) VALUES (196, 3, 34);
INSERT INTO location (id, floor, building_id) VALUES (197, 1, 28);
INSERT INTO location (id, floor, building_id) VALUES (198, 3, 25);
INSERT INTO location (id, floor, building_id) VALUES (199, 1, 36);
INSERT INTO location (id, floor, building_id) VALUES (200, 1, 36);


--
-- TOC entry 2086 (class 0 OID 0)
-- Dependencies: 170
-- Name: location_id_seq; Type: SEQUENCE SET; Schema: libdb; Owner: postgres
--

SELECT pg_catalog.setval('location_id_seq', 200, true);


--
-- TOC entry 2044 (class 0 OID 19153)
-- Dependencies: 175 2061
-- Data for Name: occupation; Type: TABLE DATA; Schema: libdb; Owner: postgres
--

INSERT INTO occupation (id, title, borrow_limit) VALUES (10, 'faculty', 15);
INSERT INTO occupation (id, title, borrow_limit) VALUES (11, 'student', 10);
INSERT INTO occupation (id, title, borrow_limit) VALUES (12, 'staff', 5);


--
-- TOC entry 2087 (class 0 OID 0)
-- Dependencies: 174
-- Name: occupation_id_seq; Type: SEQUENCE SET; Schema: libdb; Owner: postgres
--

SELECT pg_catalog.setval('occupation_id_seq', 12, true);


--
-- TOC entry 2060 (class 0 OID 19282)
-- Dependencies: 191 2061
-- Data for Name: penalty; Type: TABLE DATA; Schema: libdb; Owner: postgres
--

INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (16, '2013-05-30', '2013-10-23', 11, 93, 1);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (15, '2013-06-11', '2014-02-03', 65, 94, 1);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (12, '2013-06-07', '2013-10-24', 26, 95, 2);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (14, '2013-07-01', '2013-10-28', 42, 96, 2);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (8, '2013-04-11', '2013-11-17', 81, 97, 3);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (5, '2013-08-22', '2013-09-11', 92, 98, 1);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (19, '2013-06-10', '2013-11-26', 15, 99, 3);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (19, '2013-06-22', '2013-09-03', 1, 100, 1);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (8, '2013-05-02', '2013-10-04', 96, 101, 2);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (19, '2013-08-13', '2013-11-27', 61, 102, 3);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (18, '2013-08-19', '2013-09-17', 30, 103, 1);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (4, '2013-05-16', '2013-10-12', 44, 104, 1);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (8, '2013-04-19', '2013-09-10', 72, 105, 2);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (16, '2013-05-22', '2013-09-15', 41, 106, 2);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (15, '2013-03-19', '2014-01-27', 94, 107, 3);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (9, '2013-03-27', '2013-10-28', 49, 108, 1);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (17, '2013-05-20', '2014-02-25', 55, 109, 1);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (11, '2013-05-15', '2013-10-16', 30, 110, 3);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (17, '2013-03-11', '2014-02-21', 81, 111, 3);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (14, '2013-03-25', '2013-12-04', 74, 112, 1);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (5, '2013-07-31', '2014-01-22', 90, 113, 1);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (9, '2013-03-21', '2013-10-11', 49, 114, 3);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (19, '2013-03-26', '2013-09-25', 68, 115, 1);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (12, '2013-03-31', '2014-01-10', 77, 116, 3);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (8, '2013-07-24', '2014-03-10', 78, 117, 1);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (13, '2013-07-07', '2013-08-29', 73, 118, 3);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (14, '2013-03-22', '2013-11-13', 97, 119, 1);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (14, '2013-05-19', '2013-11-06', 14, 120, 3);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (14, '2013-04-18', '2013-12-18', 82, 121, 2);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (10, '2013-07-14', '2013-09-22', 41, 122, 1);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (8, '2013-08-17', '2013-09-30', 75, 123, 2);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (9, '2013-03-27', '2014-02-23', 52, 124, 1);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (5, '2013-03-15', '2013-10-29', 97, 125, 1);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (7, '2013-06-20', '2014-03-05', 12, 126, 1);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (14, '2013-06-27', '2013-11-17', 43, 127, 1);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (19, '2013-05-27', '2013-10-23', 39, 128, 3);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (17, '2013-06-16', '2014-02-08', 99, 129, 2);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (10, '2013-05-29', '2013-10-06', 60, 130, 1);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (8, '2013-03-17', '2013-10-10', 28, 131, 2);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (7, '2013-04-27', '2013-10-15', 46, 132, 1);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (14, '2013-05-26', '2013-10-21', 29, 133, 3);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (4, '2013-03-24', '2013-12-24', 92, 134, 2);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (17, '2013-08-08', '2013-12-12', 28, 135, 2);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (4, '2013-04-29', '2014-02-06', 27, 136, 2);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (10, '2013-05-06', '2014-02-20', 76, 137, 1);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (17, '2013-05-31', '2014-02-28', 86, 138, 2);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (5, '2013-04-14', '2013-10-05', 42, 139, 3);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (11, '2013-04-15', '2013-10-12', 60, 140, 3);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (12, '2013-07-17', '2013-09-15', 8, 141, 2);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (14, '2013-05-19', '2014-03-09', 53, 142, 3);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (18, '2013-08-14', '2013-12-06', 87, 143, 2);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (17, '2013-03-31', '2013-10-21', 45, 144, 1);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (18, '2013-03-23', '2013-12-16', 78, 145, 2);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (12, '2013-05-07', '2014-01-01', 76, 146, 1);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (8, '2013-08-07', '2013-10-08', 3, 147, 3);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (4, '2013-06-10', '2013-09-14', 73, 148, 2);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (18, '2013-07-02', '2013-11-10', 20, 149, 2);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (12, '2013-05-12', '2013-10-19', 22, 150, 1);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (11, '2013-08-14', '2014-02-09', 97, 151, 3);
INSERT INTO penalty (user_id, issue_date, clear_date, amount, book_borrow_id, penalty_reason_id) VALUES (12, '2013-06-12', '2014-02-05', 75, 152, 2);


--
-- TOC entry 2046 (class 0 OID 19161)
-- Dependencies: 177 2061
-- Data for Name: penalty_reason; Type: TABLE DATA; Schema: libdb; Owner: postgres
--

INSERT INTO penalty_reason (id, "desc") VALUES (1, 'Damaging, defacing, or misusing any Library materials or property.');
INSERT INTO penalty_reason (id, "desc") VALUES (2, 'Losing book');
INSERT INTO penalty_reason (id, "desc") VALUES (3, 'past the due for return books');
INSERT INTO penalty_reason (id, "desc") VALUES (4, 'some other reason');


--
-- TOC entry 2088 (class 0 OID 0)
-- Dependencies: 176
-- Name: penalty_reason_id_seq; Type: SEQUENCE SET; Schema: libdb; Owner: postgres
--

SELECT pg_catalog.setval('penalty_reason_id_seq', 1, false);


--
-- TOC entry 2036 (class 0 OID 19107)
-- Dependencies: 167 2061
-- Data for Name: publisher; Type: TABLE DATA; Schema: libdb; Owner: postgres
--

INSERT INTO publisher (id, name, email, phone) VALUES (1, 'AGDHTDD', '4IJ2UIU@gmail.com', NULL);
INSERT INTO publisher (id, name, email, phone) VALUES (2, 'CK0CJGG', '120CCQG@gmail.com', NULL);
INSERT INTO publisher (id, name, email, phone) VALUES (3, 'FAI7RJM', 'B3995IL@gmail.com', NULL);
INSERT INTO publisher (id, name, email, phone) VALUES (4, 'W99XVRX', '8YCDQJI@gmail.com', NULL);
INSERT INTO publisher (id, name, email, phone) VALUES (5, 'L6JB3L9', 'WLPYSWU@gmail.com', NULL);
INSERT INTO publisher (id, name, email, phone) VALUES (6, '4CW7DA2', 'DHPOUKP@gmail.com', NULL);
INSERT INTO publisher (id, name, email, phone) VALUES (7, 'O4DG5YX', 'XJ7E6S9@gmail.com', NULL);
INSERT INTO publisher (id, name, email, phone) VALUES (8, 'X042S9U', 'GWFDKMA@gmail.com', NULL);
INSERT INTO publisher (id, name, email, phone) VALUES (9, 'MS1NKMK', '785G72F@gmail.com', NULL);
INSERT INTO publisher (id, name, email, phone) VALUES (10, 'LXNO9KJ', '3STSXPC@gmail.com', NULL);


--
-- TOC entry 2089 (class 0 OID 0)
-- Dependencies: 166
-- Name: publisher_id_seq; Type: SEQUENCE SET; Schema: libdb; Owner: postgres
--

SELECT pg_catalog.setval('publisher_id_seq', 10, true);


--
-- TOC entry 2034 (class 0 OID 19093)
-- Dependencies: 165 2061
-- Data for Name: sub_category; Type: TABLE DATA; Schema: libdb; Owner: postgres
--

INSERT INTO sub_category (id, name, category_id) VALUES (1, 'Business & Economics', 2);
INSERT INTO sub_category (id, name, category_id) VALUES (2, 'Careers', 2);
INSERT INTO sub_category (id, name, category_id) VALUES (3, 'Computers & the Internet', 2);
INSERT INTO sub_category (id, name, category_id) VALUES (4, 'Management', 2);
INSERT INTO sub_category (id, name, category_id) VALUES (5, 'Action & Adventure', 3);
INSERT INTO sub_category (id, name, category_id) VALUES (6, 'Classics', 3);
INSERT INTO sub_category (id, name, category_id) VALUES (7, 'Fantasy', 3);
INSERT INTO sub_category (id, name, category_id) VALUES (8, 'General', 3);
INSERT INTO sub_category (id, name, category_id) VALUES (9, 'Literary', 3);
INSERT INTO sub_category (id, name, category_id) VALUES (10, 'Mystery', 3);
INSERT INTO sub_category (id, name, category_id) VALUES (11, 'Oprah''s Book Club® Selections', 3);
INSERT INTO sub_category (id, name, category_id) VALUES (12, 'Romance', 3);
INSERT INTO sub_category (id, name, category_id) VALUES (13, 'Suspense & Thrillers', 3);
INSERT INTO sub_category (id, name, category_id) VALUES (14, 'Science Fiction', 3);
INSERT INTO sub_category (id, name, category_id) VALUES (15, 'Western', 3);
INSERT INTO sub_category (id, name, category_id) VALUES (16, 'Arts, Architecture, Photography', 4);
INSERT INTO sub_category (id, name, category_id) VALUES (17, 'Automotive', 4);
INSERT INTO sub_category (id, name, category_id) VALUES (18, 'Biography, Autobiography, Memoir', 4);
INSERT INTO sub_category (id, name, category_id) VALUES (19, 'Cooking, Food, Drink', 4);
INSERT INTO sub_category (id, name, category_id) VALUES (20, 'Entertainment', 4);
INSERT INTO sub_category (id, name, category_id) VALUES (21, 'Health, Fitness, Beauty', 4);
INSERT INTO sub_category (id, name, category_id) VALUES (22, 'History', 4);
INSERT INTO sub_category (id, name, category_id) VALUES (23, 'Hobbies, Puzzle, & Games', 4);
INSERT INTO sub_category (id, name, category_id) VALUES (24, 'Home & Garden', 4);
INSERT INTO sub_category (id, name, category_id) VALUES (25, 'Mind, Body, Spirit', 4);
INSERT INTO sub_category (id, name, category_id) VALUES (26, 'Performing Arts', 4);
INSERT INTO sub_category (id, name, category_id) VALUES (27, 'Philosophy', 4);
INSERT INTO sub_category (id, name, category_id) VALUES (28, 'Reference', 4);
INSERT INTO sub_category (id, name, category_id) VALUES (29, 'Religion, Spirituality', 4);
INSERT INTO sub_category (id, name, category_id) VALUES (30, 'Science & Nature', 4);
INSERT INTO sub_category (id, name, category_id) VALUES (31, 'Sports', 4);
INSERT INTO sub_category (id, name, category_id) VALUES (32, 'African-American Interest', 5);
INSERT INTO sub_category (id, name, category_id) VALUES (33, 'Award Winners', 5);
INSERT INTO sub_category (id, name, category_id) VALUES (34, 'Audiobooks', 5);
INSERT INTO sub_category (id, name, category_id) VALUES (35, 'Bestsellers', 5);
INSERT INTO sub_category (id, name, category_id) VALUES (36, 'Book Club Reading Guides', 5);
INSERT INTO sub_category (id, name, category_id) VALUES (37, 'Ebooks', 5);
INSERT INTO sub_category (id, name, category_id) VALUES (38, 'Latino Interest', 5);
INSERT INTO sub_category (id, name, category_id) VALUES (39, 'Penguin Classics', 5);
INSERT INTO sub_category (id, name, category_id) VALUES (40, 'Short Reads', 5);
INSERT INTO sub_category (id, name, category_id) VALUES (41, 'Upcoming Books', 5);
INSERT INTO sub_category (id, name, category_id) VALUES (42, 'For Ages 0-3', 6);
INSERT INTO sub_category (id, name, category_id) VALUES (43, 'For Ages 4-6', 6);
INSERT INTO sub_category (id, name, category_id) VALUES (44, 'For Ages 7-9', 6);
INSERT INTO sub_category (id, name, category_id) VALUES (45, 'For Ages 10-Up', 6);
INSERT INTO sub_category (id, name, category_id) VALUES (46, 'Cam Jansen', 6);
INSERT INTO sub_category (id, name, category_id) VALUES (47, 'Hank the Cowdog', 6);
INSERT INTO sub_category (id, name, category_id) VALUES (48, 'Hank Zipzer', 6);
INSERT INTO sub_category (id, name, category_id) VALUES (49, 'Hardy Boys', 6);
INSERT INTO sub_category (id, name, category_id) VALUES (50, 'Hoofbeats', 6);
INSERT INTO sub_category (id, name, category_id) VALUES (51, 'Katie Kazoo', 6);
INSERT INTO sub_category (id, name, category_id) VALUES (52, 'The Little Engine that Could', 6);
INSERT INTO sub_category (id, name, category_id) VALUES (53, 'Madeline', 6);
INSERT INTO sub_category (id, name, category_id) VALUES (54, 'Mr. Men & Little Miss', 6);
INSERT INTO sub_category (id, name, category_id) VALUES (55, 'Nancy Drew', 6);
INSERT INTO sub_category (id, name, category_id) VALUES (56, 'Peter Rabbit', 6);
INSERT INTO sub_category (id, name, category_id) VALUES (57, 'Redwall', 6);
INSERT INTO sub_category (id, name, category_id) VALUES (58, 'North America', 7);
INSERT INTO sub_category (id, name, category_id) VALUES (59, 'Central America & Caribbean', 7);
INSERT INTO sub_category (id, name, category_id) VALUES (60, 'South America', 7);
INSERT INTO sub_category (id, name, category_id) VALUES (61, 'Europe & Russia', 7);
INSERT INTO sub_category (id, name, category_id) VALUES (62, 'Asia', 7);
INSERT INTO sub_category (id, name, category_id) VALUES (63, 'Africa & Middle East', 7);
INSERT INTO sub_category (id, name, category_id) VALUES (64, 'Australia & South Pacific', 7);
INSERT INTO sub_category (id, name, category_id) VALUES (65, 'Travel Writing', 7);


--
-- TOC entry 2090 (class 0 OID 0)
-- Dependencies: 164
-- Name: sub_category_id_seq; Type: SEQUENCE SET; Schema: libdb; Owner: postgres
--

SELECT pg_catalog.setval('sub_category_id_seq', 65, true);


--
-- TOC entry 2048 (class 0 OID 19169)
-- Dependencies: 179 2061
-- Data for Name: user; Type: TABLE DATA; Schema: libdb; Owner: postgres
--

INSERT INTO "user" (id, lastname, firstname, middlename, email, phone, since, occupation_id) VALUES (4, 'BROWN', 'Audrey', NULL, 'YJZGFZMQKB@dell.com', '5987524471', '1966-09-19', 10);
INSERT INTO "user" (id, lastname, firstname, middlename, email, phone, since, occupation_id) VALUES (5, 'EDWARDS', 'Eric', NULL, 'HWBFUJHRYF@dell.com', '5047589953', '1969-05-06', 10);
INSERT INTO "user" (id, lastname, firstname, middlename, email, phone, since, occupation_id) VALUES (6, 'EVANS', 'Christin', NULL, 'HQTSOTTNHH@dell.com', '4439042065', '1966-07-19', 11);
INSERT INTO "user" (id, lastname, firstname, middlename, email, phone, since, occupation_id) VALUES (7, 'SMITH', 'Britney', NULL, 'FZQVSKLNKM@dell.com', '8625074421', '1935-03-03', 10);
INSERT INTO "user" (id, lastname, firstname, middlename, email, phone, since, occupation_id) VALUES (8, 'STEWART', 'Jasmin', NULL, 'MFMYBNLXCX@dell.com', '7139053286', '1929-02-17', 10);
INSERT INTO "user" (id, lastname, firstname, middlename, email, phone, since, occupation_id) VALUES (9, 'LANDRY', 'Ann', NULL, 'CZOTDBHSJZ@dell.com', '9853416732', '1947-12-26', 10);
INSERT INTO "user" (id, lastname, firstname, middlename, email, phone, since, occupation_id) VALUES (10, 'RODRIGUEZ', 'Rachel', NULL, 'AFTKZOHFBH@dell.com', '9008835985', '1973-03-12', 12);
INSERT INTO "user" (id, lastname, firstname, middlename, email, phone, since, occupation_id) VALUES (11, 'WATSON', 'Selina', NULL, 'SBITYYLUHD@dell.com', '8947965950', '1987-12-22', 12);
INSERT INTO "user" (id, lastname, firstname, middlename, email, phone, since, occupation_id) VALUES (12, 'LEONARD', 'Elizabet', NULL, 'USAIRWQAXB@dell.com', '3056131893', '1922-12-01', 12);
INSERT INTO "user" (id, lastname, firstname, middlename, email, phone, since, occupation_id) VALUES (13, 'HALL', 'Cheyenne', NULL, 'MZNJMGUYPD@dell.com', '4772522998', '1981-04-14', 11);
INSERT INTO "user" (id, lastname, firstname, middlename, email, phone, since, occupation_id) VALUES (14, 'RUSH', 'Tatiana', NULL, 'CJPTWKUEFF@dell.com', '9508110149', '1983-12-27', 10);
INSERT INTO "user" (id, lastname, firstname, middlename, email, phone, since, occupation_id) VALUES (15, 'VARGAS', 'Megan', NULL, 'SOXSFUIZCS@dell.com', '6167495029', '1941-08-10', 12);
INSERT INTO "user" (id, lastname, firstname, middlename, email, phone, since, occupation_id) VALUES (16, 'WHITE', 'Jordan', NULL, 'TBAOJRQHAS@dell.com', '8026470031', '1981-08-12', 12);
INSERT INTO "user" (id, lastname, firstname, middlename, email, phone, since, occupation_id) VALUES (17, 'MOODY', 'Emily', NULL, 'SLDCVJNIOF@dell.com', '7824551207', '1984-07-28', 12);
INSERT INTO "user" (id, lastname, firstname, middlename, email, phone, since, occupation_id) VALUES (18, 'FARRELL', 'Rachel', NULL, 'HULEXGVVSD@dell.com', '6159942382', '1926-09-26', 12);
INSERT INTO "user" (id, lastname, firstname, middlename, email, phone, since, occupation_id) VALUES (19, 'JOHNSON', 'Tanisha', NULL, 'BDLANJFVMB@dell.com', '2550574922', '1945-12-20', 10);
INSERT INTO "user" (id, lastname, firstname, middlename, email, phone, since, occupation_id) VALUES (20, 'LARSON', 'Rachel', NULL, 'GTNPFNTDPL@dell.com', '8282564917', '1984-11-24', 11);


--
-- TOC entry 2091 (class 0 OID 0)
-- Dependencies: 178
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: libdb; Owner: postgres
--

SELECT pg_catalog.setval('user_id_seq', 20, true);


--
-- TOC entry 2054 (class 0 OID 19226)
-- Dependencies: 185 2061
-- Data for Name: wishlist; Type: TABLE DATA; Schema: libdb; Owner: postgres
--

INSERT INTO wishlist (id, isbn, request_date, status, user_id) VALUES (1, 'AJP17L94OBWN87', '2014-03-09', 0, 12);
INSERT INTO wishlist (id, isbn, request_date, status, user_id) VALUES (2, 'QNJGC1XUBW8DKE', '2014-03-08', 0, 18);
INSERT INTO wishlist (id, isbn, request_date, status, user_id) VALUES (3, '0WHMJP2FWJ8AC6', '2014-03-07', 1, 6);
INSERT INTO wishlist (id, isbn, request_date, status, user_id) VALUES (4, 'CJ48UAMEXWYEFX', '2014-03-06', 1, 18);
INSERT INTO wishlist (id, isbn, request_date, status, user_id) VALUES (5, 'ULRJE5S96B0LBF', '2014-03-05', 1, 15);
INSERT INTO wishlist (id, isbn, request_date, status, user_id) VALUES (6, 'IK11GVWARFEB4E', '2014-03-04', 1, 9);
INSERT INTO wishlist (id, isbn, request_date, status, user_id) VALUES (7, 'IY7W9745C4EGRT', '2014-03-03', 1, 9);
INSERT INTO wishlist (id, isbn, request_date, status, user_id) VALUES (8, 'ETGE64LENMGPTM', '2014-03-02', 1, 17);
INSERT INTO wishlist (id, isbn, request_date, status, user_id) VALUES (9, 'LB3RAO3U0QP3FN', '2014-03-01', 1, 7);
INSERT INTO wishlist (id, isbn, request_date, status, user_id) VALUES (10, 'H2BPYIQLBLDQGQ', '2014-02-28', 1, 10);
INSERT INTO wishlist (id, isbn, request_date, status, user_id) VALUES (11, 'YE9GD3PQ1PUGWF', '2014-02-27', 0, 7);
INSERT INTO wishlist (id, isbn, request_date, status, user_id) VALUES (12, 'KQQNNO9MXW6TAX', '2014-02-26', 1, 19);
INSERT INTO wishlist (id, isbn, request_date, status, user_id) VALUES (13, '59XAQWGYDDYF08', '2014-02-25', 0, 19);
INSERT INTO wishlist (id, isbn, request_date, status, user_id) VALUES (14, 'O17F6QVWY6KTKK', '2014-02-24', 0, 12);
INSERT INTO wishlist (id, isbn, request_date, status, user_id) VALUES (15, '86HAEF19MTSE0D', '2014-02-23', 0, 16);
INSERT INTO wishlist (id, isbn, request_date, status, user_id) VALUES (16, 'CN9SG2M9VR1SA9', '2014-02-22', 0, 5);
INSERT INTO wishlist (id, isbn, request_date, status, user_id) VALUES (17, '4VU21O9JSO9RJB', '2014-02-21', 0, 14);
INSERT INTO wishlist (id, isbn, request_date, status, user_id) VALUES (18, 'HTM39PKHHGX5L4', '2014-02-20', 0, 10);
INSERT INTO wishlist (id, isbn, request_date, status, user_id) VALUES (19, '105KLHDRMOVDG3', '2014-02-19', 1, 14);
INSERT INTO wishlist (id, isbn, request_date, status, user_id) VALUES (20, '00I1YF7V8CC7R9', '2014-02-18', 1, 9);
INSERT INTO wishlist (id, isbn, request_date, status, user_id) VALUES (21, 'AKSDQ653BY9586', '2014-02-17', 0, 7);
INSERT INTO wishlist (id, isbn, request_date, status, user_id) VALUES (22, 'TIO8BT0TOHFIO6', '2014-02-16', 1, 14);
INSERT INTO wishlist (id, isbn, request_date, status, user_id) VALUES (23, 'LRTKIWDXVEJ08I', '2014-02-15', 0, 12);
INSERT INTO wishlist (id, isbn, request_date, status, user_id) VALUES (24, 'KG1TQGOTG3V7NK', '2014-02-14', 0, 6);
INSERT INTO wishlist (id, isbn, request_date, status, user_id) VALUES (25, 'JYS620MFQIT2S5', '2014-02-13', 0, 6);
INSERT INTO wishlist (id, isbn, request_date, status, user_id) VALUES (26, 'S40P13N13CR730', '2014-02-12', 0, 19);
INSERT INTO wishlist (id, isbn, request_date, status, user_id) VALUES (27, 'GTN7OW1WVGMX20', '2014-02-11', 0, 19);
INSERT INTO wishlist (id, isbn, request_date, status, user_id) VALUES (28, 'UL7RHK2B5GCMFU', '2014-02-10', 0, 13);
INSERT INTO wishlist (id, isbn, request_date, status, user_id) VALUES (29, 'LMMEXS5LDF6EHE', '2014-02-09', 1, 9);
INSERT INTO wishlist (id, isbn, request_date, status, user_id) VALUES (30, 'BAAU9H2CSWF1MC', '2014-02-08', 0, 16);


--
-- TOC entry 2092 (class 0 OID 0)
-- Dependencies: 184
-- Name: wishlist_id_seq; Type: SEQUENCE SET; Schema: libdb; Owner: postgres
--

SELECT pg_catalog.setval('wishlist_id_seq', 30, true);


--
-- TOC entry 1902 (class 2606 OID 19265)
-- Dependencies: 189 189 2062
-- Name: author_pkey; Type: CONSTRAINT; Schema: libdb; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY author
    ADD CONSTRAINT author_pkey PRIMARY KEY (id);


--
-- TOC entry 1907 (class 2606 OID 19270)
-- Dependencies: 190 190 190 2062
-- Name: authorize_pkey; Type: CONSTRAINT; Schema: libdb; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY authorize
    ADD CONSTRAINT authorize_pkey PRIMARY KEY (author_id, book_id);


--
-- TOC entry 1898 (class 2606 OID 19245)
-- Dependencies: 187 187 2062
-- Name: book_borrow_pkey; Type: CONSTRAINT; Schema: libdb; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY book_borrow
    ADD CONSTRAINT book_borrow_pkey PRIMARY KEY (id);


--
-- TOC entry 1889 (class 2606 OID 19211)
-- Dependencies: 183 183 2062
-- Name: book_copy_pkey; Type: CONSTRAINT; Schema: libdb; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY book_copy
    ADD CONSTRAINT book_copy_pkey PRIMARY KEY (id);


--
-- TOC entry 1882 (class 2606 OID 19191)
-- Dependencies: 181 181 2062
-- Name: book_pkey; Type: CONSTRAINT; Schema: libdb; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY book
    ADD CONSTRAINT book_pkey PRIMARY KEY (id);


--
-- TOC entry 1869 (class 2606 OID 19144)
-- Dependencies: 173 173 2062
-- Name: bookshelf_pkey; Type: CONSTRAINT; Schema: libdb; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY bookshelf
    ADD CONSTRAINT bookshelf_pkey PRIMARY KEY (id);


--
-- TOC entry 1864 (class 2606 OID 19122)
-- Dependencies: 169 169 2062
-- Name: building_pkey; Type: CONSTRAINT; Schema: libdb; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY building
    ADD CONSTRAINT building_pkey PRIMARY KEY (id);


--
-- TOC entry 1854 (class 2606 OID 19089)
-- Dependencies: 163 163 2062
-- Name: category_pkey; Type: CONSTRAINT; Schema: libdb; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY category
    ADD CONSTRAINT category_pkey PRIMARY KEY (id);


--
-- TOC entry 1867 (class 2606 OID 19130)
-- Dependencies: 171 171 2062
-- Name: location_pkey; Type: CONSTRAINT; Schema: libdb; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY location
    ADD CONSTRAINT location_pkey PRIMARY KEY (id);


--
-- TOC entry 1872 (class 2606 OID 19158)
-- Dependencies: 175 175 2062
-- Name: occupation_pkey; Type: CONSTRAINT; Schema: libdb; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY occupation
    ADD CONSTRAINT occupation_pkey PRIMARY KEY (id);


--
-- TOC entry 1913 (class 2606 OID 19286)
-- Dependencies: 191 191 2062
-- Name: penalty_pkey; Type: CONSTRAINT; Schema: libdb; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY penalty
    ADD CONSTRAINT penalty_pkey PRIMARY KEY (book_borrow_id);


--
-- TOC entry 1874 (class 2606 OID 19166)
-- Dependencies: 177 177 2062
-- Name: penalty_reason_pkey; Type: CONSTRAINT; Schema: libdb; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY penalty_reason
    ADD CONSTRAINT penalty_reason_pkey PRIMARY KEY (id);


--
-- TOC entry 1862 (class 2606 OID 19112)
-- Dependencies: 167 167 2062
-- Name: publisher_pkey; Type: CONSTRAINT; Schema: libdb; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY publisher
    ADD CONSTRAINT publisher_pkey PRIMARY KEY (id);


--
-- TOC entry 1858 (class 2606 OID 19098)
-- Dependencies: 165 165 2062
-- Name: sub_category_pkey; Type: CONSTRAINT; Schema: libdb; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sub_category
    ADD CONSTRAINT sub_category_pkey PRIMARY KEY (id);


--
-- TOC entry 1879 (class 2606 OID 19174)
-- Dependencies: 179 179 2062
-- Name: user_pkey; Type: CONSTRAINT; Schema: libdb; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- TOC entry 1896 (class 2606 OID 19231)
-- Dependencies: 185 185 2062
-- Name: wishlist_pkey; Type: CONSTRAINT; Schema: libdb; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY wishlist
    ADD CONSTRAINT wishlist_pkey PRIMARY KEY (id);


--
-- TOC entry 1904 (class 1259 OID 19307)
-- Dependencies: 190 2062
-- Name: authorize_author_id_idx; Type: INDEX; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE INDEX authorize_author_id_idx ON authorize USING hash (author_id);


--
-- TOC entry 1905 (class 1259 OID 19308)
-- Dependencies: 190 2062
-- Name: authorize_book_id_idx; Type: INDEX; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE INDEX authorize_book_id_idx ON authorize USING hash (book_id);


--
-- TOC entry 1887 (class 1259 OID 19312)
-- Dependencies: 183 2062
-- Name: book_copy_book_id_idx; Type: INDEX; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE INDEX book_copy_book_id_idx ON book_copy USING hash (book_id);


--
-- TOC entry 1890 (class 1259 OID 19313)
-- Dependencies: 183 2062
-- Name: book_copy_status_idx; Type: INDEX; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE INDEX book_copy_status_idx ON book_copy USING btree (status);


--
-- TOC entry 1880 (class 1259 OID 19309)
-- Dependencies: 181 2062
-- Name: book_isbn_idx; Type: INDEX; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE INDEX book_isbn_idx ON book USING btree (isbn);


--
-- TOC entry 1883 (class 1259 OID 19311)
-- Dependencies: 181 2062
-- Name: book_publisher_idx; Type: INDEX; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE INDEX book_publisher_idx ON book USING hash (publisher_id);


--
-- TOC entry 1884 (class 1259 OID 19310)
-- Dependencies: 181 2062
-- Name: book_title_idx; Type: INDEX; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE INDEX book_title_idx ON book USING btree (title);


--
-- TOC entry 1859 (class 1259 OID 19113)
-- Dependencies: 167 2062
-- Name: email_UNIQUE; Type: INDEX; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX "email_UNIQUE" ON publisher USING btree (email);


--
-- TOC entry 1908 (class 1259 OID 19281)
-- Dependencies: 190 2062
-- Name: fk_authorize_book1_idx; Type: INDEX; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE INDEX fk_authorize_book1_idx ON authorize USING btree (book_id);


--
-- TOC entry 1899 (class 1259 OID 19257)
-- Dependencies: 187 2062
-- Name: fk_book_borrow_book_copy1_idx; Type: INDEX; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE INDEX fk_book_borrow_book_copy1_idx ON book_borrow USING btree (book_copy_id);


--
-- TOC entry 1900 (class 1259 OID 19256)
-- Dependencies: 187 2062
-- Name: fk_book_borrow_user1_idx; Type: INDEX; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE INDEX fk_book_borrow_user1_idx ON book_borrow USING btree (user_id);


--
-- TOC entry 1891 (class 1259 OID 19222)
-- Dependencies: 183 2062
-- Name: fk_book_copy_book1_idx; Type: INDEX; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE INDEX fk_book_copy_book1_idx ON book_copy USING btree (book_id);


--
-- TOC entry 1892 (class 1259 OID 19223)
-- Dependencies: 183 2062
-- Name: fk_book_copy_bookshelf1_idx; Type: INDEX; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE INDEX fk_book_copy_bookshelf1_idx ON book_copy USING btree (bookshelf_id);


--
-- TOC entry 1885 (class 1259 OID 19202)
-- Dependencies: 181 2062
-- Name: fk_book_publisher1_idx; Type: INDEX; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE INDEX fk_book_publisher1_idx ON book USING btree (publisher_id);


--
-- TOC entry 1886 (class 1259 OID 19203)
-- Dependencies: 181 2062
-- Name: fk_book_sub_category1_idx; Type: INDEX; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE INDEX fk_book_sub_category1_idx ON book USING btree (sub_category_id);


--
-- TOC entry 1870 (class 1259 OID 19150)
-- Dependencies: 173 2062
-- Name: fk_bookshelf_location1_idx; Type: INDEX; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE INDEX fk_bookshelf_location1_idx ON bookshelf USING btree (location_id);


--
-- TOC entry 1865 (class 1259 OID 19136)
-- Dependencies: 171 2062
-- Name: fk_location_building1_idx; Type: INDEX; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE INDEX fk_location_building1_idx ON location USING btree (building_id);


--
-- TOC entry 1909 (class 1259 OID 19304)
-- Dependencies: 191 2062
-- Name: fk_penalty_book_copy1_idx; Type: INDEX; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE INDEX fk_penalty_book_copy1_idx ON penalty USING btree (book_borrow_id);


--
-- TOC entry 1910 (class 1259 OID 19302)
-- Dependencies: 191 2062
-- Name: fk_penalty_penalty_reason1_idx; Type: INDEX; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE INDEX fk_penalty_penalty_reason1_idx ON penalty USING btree (penalty_reason_id);


--
-- TOC entry 1911 (class 1259 OID 19303)
-- Dependencies: 191 2062
-- Name: fk_penalty_user1_idx; Type: INDEX; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE INDEX fk_penalty_user1_idx ON penalty USING btree (user_id);


--
-- TOC entry 1856 (class 1259 OID 19104)
-- Dependencies: 165 2062
-- Name: fk_sub_category_category_idx; Type: INDEX; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE INDEX fk_sub_category_category_idx ON sub_category USING btree (category_id);


--
-- TOC entry 1875 (class 1259 OID 19180)
-- Dependencies: 179 2062
-- Name: fk_user_occupation1_idx; Type: INDEX; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE INDEX fk_user_occupation1_idx ON "user" USING btree (occupation_id);


--
-- TOC entry 1893 (class 1259 OID 19237)
-- Dependencies: 185 2062
-- Name: fk_wishlist_user1_idx; Type: INDEX; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE INDEX fk_wishlist_user1_idx ON wishlist USING btree (user_id);


--
-- TOC entry 1903 (class 1259 OID 19306)
-- Dependencies: 189 2062
-- Name: id_idx; Type: INDEX; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE INDEX id_idx ON author USING btree (id);


--
-- TOC entry 1855 (class 1259 OID 19090)
-- Dependencies: 163 2062
-- Name: name_UNIQUE; Type: INDEX; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX "name_UNIQUE" ON category USING btree (name);


--
-- TOC entry 1860 (class 1259 OID 19114)
-- Dependencies: 167 2062
-- Name: phone_UNIQUE; Type: INDEX; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX "phone_UNIQUE" ON publisher USING btree (phone);


--
-- TOC entry 1876 (class 1259 OID 19317)
-- Dependencies: 179 2062
-- Name: user_firstname_idx; Type: INDEX; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE INDEX user_firstname_idx ON "user" USING btree (firstname);


--
-- TOC entry 1877 (class 1259 OID 19318)
-- Dependencies: 179 2062
-- Name: user_lastname_idx; Type: INDEX; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE INDEX user_lastname_idx ON "user" USING btree (lastname);


--
-- TOC entry 1894 (class 1259 OID 19319)
-- Dependencies: 185 2062
-- Name: wishlist_isbn_idx; Type: INDEX; Schema: libdb; Owner: postgres; Tablespace: 
--

CREATE INDEX wishlist_isbn_idx ON wishlist USING hash (isbn);


--
-- TOC entry 1919 (class 2606 OID 19330)
-- Dependencies: 181 1861 167 2062
-- Name: book_publisher_id_fkey; Type: FK CONSTRAINT; Schema: libdb; Owner: postgres
--

ALTER TABLE ONLY book
    ADD CONSTRAINT book_publisher_id_fkey FOREIGN KEY (publisher_id) REFERENCES publisher(id);


--
-- TOC entry 1925 (class 2606 OID 19271)
-- Dependencies: 1901 190 189 2062
-- Name: fk_authorize_author1; Type: FK CONSTRAINT; Schema: libdb; Owner: postgres
--

ALTER TABLE ONLY authorize
    ADD CONSTRAINT fk_authorize_author1 FOREIGN KEY (author_id) REFERENCES author(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 1926 (class 2606 OID 19276)
-- Dependencies: 190 181 1881 2062
-- Name: fk_authorize_book1; Type: FK CONSTRAINT; Schema: libdb; Owner: postgres
--

ALTER TABLE ONLY authorize
    ADD CONSTRAINT fk_authorize_book1 FOREIGN KEY (book_id) REFERENCES book(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 1924 (class 2606 OID 19251)
-- Dependencies: 183 187 1888 2062
-- Name: fk_book_borrow_book_copy1; Type: FK CONSTRAINT; Schema: libdb; Owner: postgres
--

ALTER TABLE ONLY book_borrow
    ADD CONSTRAINT fk_book_borrow_book_copy1 FOREIGN KEY (book_copy_id) REFERENCES book_copy(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 1923 (class 2606 OID 19246)
-- Dependencies: 179 1878 187 2062
-- Name: fk_book_borrow_user1; Type: FK CONSTRAINT; Schema: libdb; Owner: postgres
--

ALTER TABLE ONLY book_borrow
    ADD CONSTRAINT fk_book_borrow_user1 FOREIGN KEY (user_id) REFERENCES "user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 1920 (class 2606 OID 19212)
-- Dependencies: 183 181 1881 2062
-- Name: fk_book_copy_book1; Type: FK CONSTRAINT; Schema: libdb; Owner: postgres
--

ALTER TABLE ONLY book_copy
    ADD CONSTRAINT fk_book_copy_book1 FOREIGN KEY (book_id) REFERENCES book(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 1921 (class 2606 OID 19217)
-- Dependencies: 1868 173 183 2062
-- Name: fk_book_copy_bookshelf1; Type: FK CONSTRAINT; Schema: libdb; Owner: postgres
--

ALTER TABLE ONLY book_copy
    ADD CONSTRAINT fk_book_copy_bookshelf1 FOREIGN KEY (bookshelf_id) REFERENCES bookshelf(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 1918 (class 2606 OID 19325)
-- Dependencies: 181 165 1857 2062
-- Name: fk_book_sub_category1; Type: FK CONSTRAINT; Schema: libdb; Owner: postgres
--

ALTER TABLE ONLY book
    ADD CONSTRAINT fk_book_sub_category1 FOREIGN KEY (sub_category_id) REFERENCES sub_category(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 1916 (class 2606 OID 19145)
-- Dependencies: 1866 171 173 2062
-- Name: fk_bookshelf_location1; Type: FK CONSTRAINT; Schema: libdb; Owner: postgres
--

ALTER TABLE ONLY bookshelf
    ADD CONSTRAINT fk_bookshelf_location1 FOREIGN KEY (location_id) REFERENCES location(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 1915 (class 2606 OID 19131)
-- Dependencies: 1863 169 171 2062
-- Name: fk_location_building1; Type: FK CONSTRAINT; Schema: libdb; Owner: postgres
--

ALTER TABLE ONLY location
    ADD CONSTRAINT fk_location_building1 FOREIGN KEY (building_id) REFERENCES building(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 1929 (class 2606 OID 19297)
-- Dependencies: 191 1897 187 2062
-- Name: fk_penalty_book_borrow_id; Type: FK CONSTRAINT; Schema: libdb; Owner: postgres
--

ALTER TABLE ONLY penalty
    ADD CONSTRAINT fk_penalty_book_borrow_id FOREIGN KEY (book_borrow_id) REFERENCES book_borrow(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 1927 (class 2606 OID 19287)
-- Dependencies: 1873 177 191 2062
-- Name: fk_penalty_penalty_reason1; Type: FK CONSTRAINT; Schema: libdb; Owner: postgres
--

ALTER TABLE ONLY penalty
    ADD CONSTRAINT fk_penalty_penalty_reason1 FOREIGN KEY (penalty_reason_id) REFERENCES penalty_reason(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 1928 (class 2606 OID 19292)
-- Dependencies: 191 1878 179 2062
-- Name: fk_penalty_user1; Type: FK CONSTRAINT; Schema: libdb; Owner: postgres
--

ALTER TABLE ONLY penalty
    ADD CONSTRAINT fk_penalty_user1 FOREIGN KEY (user_id) REFERENCES "user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 1914 (class 2606 OID 19099)
-- Dependencies: 1853 165 163 2062
-- Name: fk_sub_category_category; Type: FK CONSTRAINT; Schema: libdb; Owner: postgres
--

ALTER TABLE ONLY sub_category
    ADD CONSTRAINT fk_sub_category_category FOREIGN KEY (category_id) REFERENCES category(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 1917 (class 2606 OID 19175)
-- Dependencies: 175 1871 179 2062
-- Name: fk_user_occupation1; Type: FK CONSTRAINT; Schema: libdb; Owner: postgres
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT fk_user_occupation1 FOREIGN KEY (occupation_id) REFERENCES occupation(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 1922 (class 2606 OID 19232)
-- Dependencies: 179 1878 185 2062
-- Name: fk_wishlist_user1; Type: FK CONSTRAINT; Schema: libdb; Owner: postgres
--

ALTER TABLE ONLY wishlist
    ADD CONSTRAINT fk_wishlist_user1 FOREIGN KEY (user_id) REFERENCES "user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2014-03-25 15:41:34

--
-- PostgreSQL database dump complete
--

