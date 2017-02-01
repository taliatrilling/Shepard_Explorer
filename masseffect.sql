--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.1
-- Dumped by pg_dump version 9.6.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: backgrounds; Type: TYPE; Schema: public; Owner: taliatrilling
--

CREATE TYPE backgrounds AS ENUM (
    'Spacer',
    'Colonist',
    'Earthborn'
);


ALTER TYPE backgrounds OWNER TO taliatrilling;

--
-- Name: genders; Type: TYPE; Schema: public; Owner: taliatrilling
--

CREATE TYPE genders AS ENUM (
    'Female',
    'Male',
    'Nonbinary'
);


ALTER TYPE genders OWNER TO taliatrilling;

--
-- Name: player_classes; Type: TYPE; Schema: public; Owner: taliatrilling
--

CREATE TYPE player_classes AS ENUM (
    'Engineer',
    'Infiltrator',
    'Soldier',
    'Biotic',
    'Sentinel',
    'Adept'
);


ALTER TYPE player_classes OWNER TO taliatrilling;

--
-- Name: profiles; Type: TYPE; Schema: public; Owner: taliatrilling
--

CREATE TYPE profiles AS ENUM (
    'Sole Survivor',
    'War Hero',
    'Ruthless'
);


ALTER TYPE profiles OWNER TO taliatrilling;

--
-- Name: reputations; Type: TYPE; Schema: public; Owner: taliatrilling
--

CREATE TYPE reputations AS ENUM (
    'Paragon',
    'Renegade',
    'Paragade'
);


ALTER TYPE reputations OWNER TO taliatrilling;

--
-- Name: status; Type: TYPE; Schema: public; Owner: taliatrilling
--

CREATE TYPE status AS ENUM (
    'Alive',
    'Dead'
);


ALTER TYPE status OWNER TO taliatrilling;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: characters; Type: TABLE; Schema: public; Owner: taliatrilling
--

CREATE TABLE characters (
    char_id integer NOT NULL,
    user_id integer NOT NULL,
    shep_background backgrounds NOT NULL,
    shep_psych_profile profiles NOT NULL,
    shep_gender genders NOT NULL,
    shep_name character varying(20) NOT NULL,
    reputation reputations NOT NULL,
    player_class player_classes NOT NULL,
    played_1 boolean NOT NULL,
    played_2 boolean NOT NULL,
    played_3 boolean NOT NULL
);


ALTER TABLE characters OWNER TO taliatrilling;

--
-- Name: characters_char_id_seq; Type: SEQUENCE; Schema: public; Owner: taliatrilling
--

CREATE SEQUENCE characters_char_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE characters_char_id_seq OWNER TO taliatrilling;

--
-- Name: characters_char_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: taliatrilling
--

ALTER SEQUENCE characters_char_id_seq OWNED BY characters.char_id;


--
-- Name: decisions; Type: TABLE; Schema: public; Owner: taliatrilling
--

CREATE TABLE decisions (
    decision_id integer NOT NULL,
    decision character varying(20) NOT NULL,
    associated_game integer NOT NULL
);


ALTER TABLE decisions OWNER TO taliatrilling;

--
-- Name: decisions_decision_id_seq; Type: SEQUENCE; Schema: public; Owner: taliatrilling
--

CREATE SEQUENCE decisions_decision_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE decisions_decision_id_seq OWNER TO taliatrilling;

--
-- Name: decisions_decision_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: taliatrilling
--

ALTER SEQUENCE decisions_decision_id_seq OWNED BY decisions.decision_id;


--
-- Name: decisionsmade; Type: TABLE; Schema: public; Owner: taliatrilling
--

CREATE TABLE decisionsmade (
    made_id integer NOT NULL,
    char_id integer NOT NULL,
    decision_id integer NOT NULL,
    outcome_id integer NOT NULL
);


ALTER TABLE decisionsmade OWNER TO taliatrilling;

--
-- Name: decisionsmade_made_id_seq; Type: SEQUENCE; Schema: public; Owner: taliatrilling
--

CREATE SEQUENCE decisionsmade_made_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE decisionsmade_made_id_seq OWNER TO taliatrilling;

--
-- Name: decisionsmade_made_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: taliatrilling
--

ALTER SEQUENCE decisionsmade_made_id_seq OWNED BY decisionsmade.made_id;


--
-- Name: outcomes; Type: TABLE; Schema: public; Owner: taliatrilling
--

CREATE TABLE outcomes (
    outcome_id integer NOT NULL,
    decision_id integer NOT NULL,
    outcome character varying(20) NOT NULL
);


ALTER TABLE outcomes OWNER TO taliatrilling;

--
-- Name: outcomes_outcome_id_seq; Type: SEQUENCE; Schema: public; Owner: taliatrilling
--

CREATE SEQUENCE outcomes_outcome_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE outcomes_outcome_id_seq OWNER TO taliatrilling;

--
-- Name: outcomes_outcome_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: taliatrilling
--

ALTER SEQUENCE outcomes_outcome_id_seq OWNED BY outcomes.outcome_id;


--
-- Name: squadmates; Type: TABLE; Schema: public; Owner: taliatrilling
--

CREATE TABLE squadmates (
    squadmate_id integer NOT NULL,
    name character varying(10) NOT NULL
);


ALTER TABLE squadmates OWNER TO taliatrilling;

--
-- Name: squadmates_squadmate_id_seq; Type: SEQUENCE; Schema: public; Owner: taliatrilling
--

CREATE SEQUENCE squadmates_squadmate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE squadmates_squadmate_id_seq OWNER TO taliatrilling;

--
-- Name: squadmates_squadmate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: taliatrilling
--

ALTER SEQUENCE squadmates_squadmate_id_seq OWNED BY squadmates.squadmate_id;


--
-- Name: squadoutcomes; Type: TABLE; Schema: public; Owner: taliatrilling
--

CREATE TABLE squadoutcomes (
    squad_outcome_id integer NOT NULL,
    squadmate_id integer NOT NULL,
    char_id integer NOT NULL,
    status status NOT NULL
);


ALTER TABLE squadoutcomes OWNER TO taliatrilling;

--
-- Name: squadoutcomes_squad_outcome_id_seq; Type: SEQUENCE; Schema: public; Owner: taliatrilling
--

CREATE SEQUENCE squadoutcomes_squad_outcome_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE squadoutcomes_squad_outcome_id_seq OWNER TO taliatrilling;

--
-- Name: squadoutcomes_squad_outcome_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: taliatrilling
--

ALTER SEQUENCE squadoutcomes_squad_outcome_id_seq OWNED BY squadoutcomes.squad_outcome_id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: taliatrilling
--

CREATE TABLE users (
    user_id integer NOT NULL,
    username character varying(20) NOT NULL,
    joined_at timestamp without time zone NOT NULL
);


ALTER TABLE users OWNER TO taliatrilling;

--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: taliatrilling
--

CREATE SEQUENCE users_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_user_id_seq OWNER TO taliatrilling;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: taliatrilling
--

ALTER SEQUENCE users_user_id_seq OWNED BY users.user_id;


--
-- Name: characters char_id; Type: DEFAULT; Schema: public; Owner: taliatrilling
--

ALTER TABLE ONLY characters ALTER COLUMN char_id SET DEFAULT nextval('characters_char_id_seq'::regclass);


--
-- Name: decisions decision_id; Type: DEFAULT; Schema: public; Owner: taliatrilling
--

ALTER TABLE ONLY decisions ALTER COLUMN decision_id SET DEFAULT nextval('decisions_decision_id_seq'::regclass);


--
-- Name: decisionsmade made_id; Type: DEFAULT; Schema: public; Owner: taliatrilling
--

ALTER TABLE ONLY decisionsmade ALTER COLUMN made_id SET DEFAULT nextval('decisionsmade_made_id_seq'::regclass);


--
-- Name: outcomes outcome_id; Type: DEFAULT; Schema: public; Owner: taliatrilling
--

ALTER TABLE ONLY outcomes ALTER COLUMN outcome_id SET DEFAULT nextval('outcomes_outcome_id_seq'::regclass);


--
-- Name: squadmates squadmate_id; Type: DEFAULT; Schema: public; Owner: taliatrilling
--

ALTER TABLE ONLY squadmates ALTER COLUMN squadmate_id SET DEFAULT nextval('squadmates_squadmate_id_seq'::regclass);


--
-- Name: squadoutcomes squad_outcome_id; Type: DEFAULT; Schema: public; Owner: taliatrilling
--

ALTER TABLE ONLY squadoutcomes ALTER COLUMN squad_outcome_id SET DEFAULT nextval('squadoutcomes_squad_outcome_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: taliatrilling
--

ALTER TABLE ONLY users ALTER COLUMN user_id SET DEFAULT nextval('users_user_id_seq'::regclass);


--
-- Data for Name: characters; Type: TABLE DATA; Schema: public; Owner: taliatrilling
--

COPY characters (char_id, user_id, shep_background, shep_psych_profile, shep_gender, shep_name, reputation, player_class, played_1, played_2, played_3) FROM stdin;
1	1	Spacer	War Hero	Female	Talia	Paragon	Adept	t	t	t
\.


--
-- Name: characters_char_id_seq; Type: SEQUENCE SET; Schema: public; Owner: taliatrilling
--

SELECT pg_catalog.setval('characters_char_id_seq', 1, true);


--
-- Data for Name: decisions; Type: TABLE DATA; Schema: public; Owner: taliatrilling
--

COPY decisions (decision_id, decision, associated_game) FROM stdin;
1	Virmire survivor	1
2	Rachni Queen	1
3	Council	1
4	Wrex	1
5	Shiala	1
6	romanced1	1
7	romanced2	2
8	genophage research	2
9	crew survival	2
10	survivor escort	2
11	collector base	2
12	suicide mission	2
13	romanced3	3
14	grissom academy	3
15	krogan team	3
17	Kelly	3
18	Samara	3
19	genophage cure	3
20	geth quarians	3
21	illusive man	3
22	war readiness	3
23	final outcome	3
24	fate of Earth	3
25	squad survival	3
\.


--
-- Name: decisions_decision_id_seq; Type: SEQUENCE SET; Schema: public; Owner: taliatrilling
--

SELECT pg_catalog.setval('decisions_decision_id_seq', 25, true);


--
-- Data for Name: decisionsmade; Type: TABLE DATA; Schema: public; Owner: taliatrilling
--

COPY decisionsmade (made_id, char_id, decision_id, outcome_id) FROM stdin;
\.


--
-- Name: decisionsmade_made_id_seq; Type: SEQUENCE SET; Schema: public; Owner: taliatrilling
--

SELECT pg_catalog.setval('decisionsmade_made_id_seq', 1, false);


--
-- Data for Name: outcomes; Type: TABLE DATA; Schema: public; Owner: taliatrilling
--

COPY outcomes (outcome_id, decision_id, outcome) FROM stdin;
1	1	Kaidan
2	1	Ashley
7	2	spared
8	2	killed
9	3	saved
10	3	dead
11	4	alive
12	4	dead
13	5	alive
14	5	dead
15	6	Ashley
16	6	Liara
17	6	Kaidan
18	6	none
19	7	Jack
20	7	Miranda
21	7	Tali
22	7	Jacob
23	7	Garrus
24	7	Thane
25	7	none
26	8	saved
27	8	destroyed
29	9	chakwas only
30	9	half dead
31	9	all survive
32	10	loyal escort
33	10	non loyal escort
34	10	no escort
35	11	destroyed
36	11	saved
37	12	success
38	12	fail
39	13	Miranda
40	13	Tali
41	13	Jack
42	13	Ashley
43	13	Steve
44	13	Samantha
45	13	Garrus
46	13	Kaidan
47	13	Liara
48	14	saved
49	14	ignored
50	15	saved
51	15	sacrificed
52	17	saved
53	17	dead
54	17	unknown
55	18	stopped suicide
56	18	let suicide occur
57	18	samara not seen
58	19	cure sabotaged
59	19	cure completed
60	20	peace brokered
61	20	quarians only
62	20	geth only
63	21	convinced
64	21	unconvinced
65	22	low
66	22	medium
67	22	high
\.


--
-- Name: outcomes_outcome_id_seq; Type: SEQUENCE SET; Schema: public; Owner: taliatrilling
--

SELECT pg_catalog.setval('outcomes_outcome_id_seq', 67, true);


--
-- Data for Name: squadmates; Type: TABLE DATA; Schema: public; Owner: taliatrilling
--

COPY squadmates (squadmate_id, name) FROM stdin;
1	Miranda
2	Garrus
3	Grunt
4	Jack
5	Jacob
6	Kasumi
7	Legion
8	Mordin
9	Morinth
10	Samara
11	Tali
12	Thane
13	Zaeed
\.


--
-- Name: squadmates_squadmate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: taliatrilling
--

SELECT pg_catalog.setval('squadmates_squadmate_id_seq', 13, true);


--
-- Data for Name: squadoutcomes; Type: TABLE DATA; Schema: public; Owner: taliatrilling
--

COPY squadoutcomes (squad_outcome_id, squadmate_id, char_id, status) FROM stdin;
\.


--
-- Name: squadoutcomes_squad_outcome_id_seq; Type: SEQUENCE SET; Schema: public; Owner: taliatrilling
--

SELECT pg_catalog.setval('squadoutcomes_squad_outcome_id_seq', 1, false);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: taliatrilling
--

COPY users (user_id, username, joined_at) FROM stdin;
1	taliamax	2016-11-11 00:00:31.645845
\.


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: taliatrilling
--

SELECT pg_catalog.setval('users_user_id_seq', 1, true);


--
-- Name: characters characters_pkey; Type: CONSTRAINT; Schema: public; Owner: taliatrilling
--

ALTER TABLE ONLY characters
    ADD CONSTRAINT characters_pkey PRIMARY KEY (char_id);


--
-- Name: decisions decisions_decision_key; Type: CONSTRAINT; Schema: public; Owner: taliatrilling
--

ALTER TABLE ONLY decisions
    ADD CONSTRAINT decisions_decision_key UNIQUE (decision);


--
-- Name: decisions decisions_pkey; Type: CONSTRAINT; Schema: public; Owner: taliatrilling
--

ALTER TABLE ONLY decisions
    ADD CONSTRAINT decisions_pkey PRIMARY KEY (decision_id);


--
-- Name: decisionsmade decisionsmade_pkey; Type: CONSTRAINT; Schema: public; Owner: taliatrilling
--

ALTER TABLE ONLY decisionsmade
    ADD CONSTRAINT decisionsmade_pkey PRIMARY KEY (made_id);


--
-- Name: outcomes outcomes_pkey; Type: CONSTRAINT; Schema: public; Owner: taliatrilling
--

ALTER TABLE ONLY outcomes
    ADD CONSTRAINT outcomes_pkey PRIMARY KEY (outcome_id);


--
-- Name: squadmates squadmates_name_key; Type: CONSTRAINT; Schema: public; Owner: taliatrilling
--

ALTER TABLE ONLY squadmates
    ADD CONSTRAINT squadmates_name_key UNIQUE (name);


--
-- Name: squadmates squadmates_pkey; Type: CONSTRAINT; Schema: public; Owner: taliatrilling
--

ALTER TABLE ONLY squadmates
    ADD CONSTRAINT squadmates_pkey PRIMARY KEY (squadmate_id);


--
-- Name: squadoutcomes squadoutcomes_pkey; Type: CONSTRAINT; Schema: public; Owner: taliatrilling
--

ALTER TABLE ONLY squadoutcomes
    ADD CONSTRAINT squadoutcomes_pkey PRIMARY KEY (squad_outcome_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: taliatrilling
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: taliatrilling
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: characters characters_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: taliatrilling
--

ALTER TABLE ONLY characters
    ADD CONSTRAINT characters_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(user_id);


--
-- Name: decisionsmade decisionsmade_char_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: taliatrilling
--

ALTER TABLE ONLY decisionsmade
    ADD CONSTRAINT decisionsmade_char_id_fkey FOREIGN KEY (char_id) REFERENCES characters(char_id);


--
-- Name: decisionsmade decisionsmade_decision_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: taliatrilling
--

ALTER TABLE ONLY decisionsmade
    ADD CONSTRAINT decisionsmade_decision_id_fkey FOREIGN KEY (decision_id) REFERENCES decisions(decision_id);


--
-- Name: decisionsmade decisionsmade_outcome_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: taliatrilling
--

ALTER TABLE ONLY decisionsmade
    ADD CONSTRAINT decisionsmade_outcome_id_fkey FOREIGN KEY (outcome_id) REFERENCES outcomes(outcome_id);


--
-- Name: outcomes outcomes_decision_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: taliatrilling
--

ALTER TABLE ONLY outcomes
    ADD CONSTRAINT outcomes_decision_id_fkey FOREIGN KEY (decision_id) REFERENCES decisions(decision_id);


--
-- Name: squadoutcomes squadoutcomes_char_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: taliatrilling
--

ALTER TABLE ONLY squadoutcomes
    ADD CONSTRAINT squadoutcomes_char_id_fkey FOREIGN KEY (char_id) REFERENCES characters(char_id);


--
-- Name: squadoutcomes squadoutcomes_squadmate_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: taliatrilling
--

ALTER TABLE ONLY squadoutcomes
    ADD CONSTRAINT squadoutcomes_squadmate_id_fkey FOREIGN KEY (squadmate_id) REFERENCES squadmates(squadmate_id);


--
-- PostgreSQL database dump complete
--

