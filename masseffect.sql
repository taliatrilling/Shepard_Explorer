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
-- Name: decisiondescriptions; Type: TABLE; Schema: public; Owner: taliatrilling
--

CREATE TABLE decisiondescriptions (
    description_id integer NOT NULL,
    text character varying(500) NOT NULL,
    decision_id integer NOT NULL
);


ALTER TABLE decisiondescriptions OWNER TO taliatrilling;

--
-- Name: decisiondescriptions_description_id_seq; Type: SEQUENCE; Schema: public; Owner: taliatrilling
--

CREATE SEQUENCE decisiondescriptions_description_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE decisiondescriptions_description_id_seq OWNER TO taliatrilling;

--
-- Name: decisiondescriptions_description_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: taliatrilling
--

ALTER SEQUENCE decisiondescriptions_description_id_seq OWNED BY decisiondescriptions.description_id;


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
-- Name: outcomedescriptions; Type: TABLE; Schema: public; Owner: taliatrilling
--

CREATE TABLE outcomedescriptions (
    description_id integer NOT NULL,
    text character varying(500) NOT NULL,
    outcome_id integer NOT NULL
);


ALTER TABLE outcomedescriptions OWNER TO taliatrilling;

--
-- Name: outcomedescriptions_description_id_seq; Type: SEQUENCE; Schema: public; Owner: taliatrilling
--

CREATE SEQUENCE outcomedescriptions_description_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE outcomedescriptions_description_id_seq OWNER TO taliatrilling;

--
-- Name: outcomedescriptions_description_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: taliatrilling
--

ALTER SEQUENCE outcomedescriptions_description_id_seq OWNED BY outcomedescriptions.description_id;


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
    password character varying(80) NOT NULL,
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
-- Name: decisiondescriptions description_id; Type: DEFAULT; Schema: public; Owner: taliatrilling
--

ALTER TABLE ONLY decisiondescriptions ALTER COLUMN description_id SET DEFAULT nextval('decisiondescriptions_description_id_seq'::regclass);


--
-- Name: decisions decision_id; Type: DEFAULT; Schema: public; Owner: taliatrilling
--

ALTER TABLE ONLY decisions ALTER COLUMN decision_id SET DEFAULT nextval('decisions_decision_id_seq'::regclass);


--
-- Name: decisionsmade made_id; Type: DEFAULT; Schema: public; Owner: taliatrilling
--

ALTER TABLE ONLY decisionsmade ALTER COLUMN made_id SET DEFAULT nextval('decisionsmade_made_id_seq'::regclass);


--
-- Name: outcomedescriptions description_id; Type: DEFAULT; Schema: public; Owner: taliatrilling
--

ALTER TABLE ONLY outcomedescriptions ALTER COLUMN description_id SET DEFAULT nextval('outcomedescriptions_description_id_seq'::regclass);


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
-- Data for Name: decisiondescriptions; Type: TABLE DATA; Schema: public; Owner: taliatrilling
--

COPY decisiondescriptions (description_id, text, decision_id) FROM stdin;
1	Which squadmate did you save on Virmire? The hunky sentinel or the spunky soldier?	1
2	Did you free the Rachni Queen on Noveria or did you kill her, allowing the Rachni to remain extinct (for the time being)?	2
3	Did the council survive the attack on the Citadel, or did you choose to not send reinforcements to the Ascension, allowing them to die?	3
4	Were you able to convince Wrex to allow you to destroy the base on Virmire, or were you forced to kill him?	4
5	Did Shiala survive her encounter with Shepard and the Thorian, or did you kill her for her role in helping Saren?	5
6	Did you choose to woo a squadmate, and if so, who was it?	6
7	Who won your newly-reconstructed heart?	7
8	Did you allow Mordin to save Maelon"s research on the genophage?	8
9	Did your auxiliary crew survive the collector attack, or were they turned into human goo?	9
10	Did you send a squadmate to escort the auxiliary crew back to the Normandy, and if so, were they loyal?	10
11	Did you destroy the collector base, or did you let the Illusive Man talk you into saving it for, uh, whatever weird explanation he gave?	11
12	Was the suicide mission a success, or did Shepard perish in a fiery chasm?	12
13	Who did you choose to cuddle with in the face of humanity"s extinction?	13
14	Did you save Arlakh Company or the Rachni Queen?	15
15	Did Kelly survive Cerberus"s attack on the Citadel?	17
16	Did Samara kill herself, or did you convince her to live and join the war effort?	18
17	Was the genophage ended, or did you sabotage the cure?	19
18	What was the outcome of the Geth-Quarian war?	20
19	Were you able to convince the Illusive Man to see the error of his ways?	21
20	What was your final war readiness?	22
21	What was the final outcome of Shepard"s discussion with the Catalyst?	23
22	What was the final fate of Earth?	24
23	Did your squad survive the events with the Catalyst?	25
\.


--
-- Name: decisiondescriptions_description_id_seq; Type: SEQUENCE SET; Schema: public; Owner: taliatrilling
--

SELECT pg_catalog.setval('decisiondescriptions_description_id_seq', 23, true);


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

SELECT pg_catalog.setval('decisionsmade_made_id_seq', 2, true);


--
-- Data for Name: outcomedescriptions; Type: TABLE DATA; Schema: public; Owner: taliatrilling
--

COPY outcomedescriptions (description_id, text, outcome_id) FROM stdin;
\.


--
-- Name: outcomedescriptions_description_id_seq; Type: SEQUENCE SET; Schema: public; Owner: taliatrilling
--

SELECT pg_catalog.setval('outcomedescriptions_description_id_seq', 1, false);


--
-- Data for Name: outcomes; Type: TABLE DATA; Schema: public; Owner: taliatrilling
--

COPY outcomes (outcome_id, decision_id, outcome) FROM stdin;
1	1	Kaidan
2	1	Ashley
3	2	spared
4	2	killed
5	3	saved
6	3	dead
7	4	alive
8	4	dead
9	5	alive
10	5	dead
11	6	Ashley
12	6	Liara
13	6	Kaidan
14	6	none
15	7	Jack
16	7	Miranda
17	7	Tali
18	7	Jacob
19	7	Garrus
20	7	Thane
21	7	none
22	8	saved
23	8	destroyed
24	9	chakwas only
25	9	half dead
26	9	all survive
27	10	loyal escort
28	10	non loyal escort
29	10	no escort
30	11	destroyed
31	11	saved
32	12	success
33	12	fail
34	13	Miranda
35	13	Tali
36	13	Jack
37	13	Ashley
38	13	Steve
39	13	Samantha
40	13	Garrus
41	13	Kaidan
42	13	Liara
43	14	saved
44	14	ignored
45	15	saved
46	15	sacrificed
47	17	saved
48	17	dead
49	17	unknown
50	18	stopped suicide
51	18	let suicide occur
52	18	samara not seen
53	19	cure sabotaged
54	19	cure completed
55	20	peace brokered
56	20	quarians only
57	20	geth only
58	21	convinced
59	21	unconvinced
60	22	1749
61	22	2049
62	22	2349
63	22	2649
64	22	2799
65	22	3999
66	22	4000
67	23	destroy
68	23	control
69	23	synthesis
70	23	refusal
71	24	vaporized
72	24	devastated
73	24	saved
74	25	no survivors
75	25	survive
76	25	survive synthesized
\.


--
-- Name: outcomes_outcome_id_seq; Type: SEQUENCE SET; Schema: public; Owner: taliatrilling
--

SELECT pg_catalog.setval('outcomes_outcome_id_seq', 76, true);


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

COPY users (user_id, username, password, joined_at) FROM stdin;
1	taliamax	$2b$12$HduwMXQ4.TWLlyops8e7O.PFty.C9L.MfOCWbgDiAvMuUV8JdXysq	2016-11-11 00:00:31.645845
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
-- Name: decisiondescriptions decisiondescriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: taliatrilling
--

ALTER TABLE ONLY decisiondescriptions
    ADD CONSTRAINT decisiondescriptions_pkey PRIMARY KEY (description_id);


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
-- Name: outcomedescriptions outcomedescriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: taliatrilling
--

ALTER TABLE ONLY outcomedescriptions
    ADD CONSTRAINT outcomedescriptions_pkey PRIMARY KEY (description_id);


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
-- Name: decisiondescriptions decisiondescriptions_decision_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: taliatrilling
--

ALTER TABLE ONLY decisiondescriptions
    ADD CONSTRAINT decisiondescriptions_decision_id_fkey FOREIGN KEY (decision_id) REFERENCES decisions(decision_id);


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
-- Name: outcomedescriptions outcomedescriptions_outcome_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: taliatrilling
--

ALTER TABLE ONLY outcomedescriptions
    ADD CONSTRAINT outcomedescriptions_outcome_id_fkey FOREIGN KEY (outcome_id) REFERENCES outcomes(outcome_id);


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

