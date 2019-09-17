--
-- PostgreSQL database dump
--

-- Dumped from database version 10.10
-- Dumped by pg_dump version 10.10

-- Started on 2019-09-17 16:20:13 CEST

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 1 (class 3079 OID 13241)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 3182 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 2 (class 3079 OID 16429)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- TOC entry 3183 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 199 (class 1259 OID 16493)
-- Name: currencyaccount; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.currencyaccount (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    owner uuid,
    currency text
);


ALTER TABLE public.currencyaccount OWNER TO postgres;

--
-- TOC entry 197 (class 1259 OID 16466)
-- Name: owner; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.owner (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    name text NOT NULL,
    country_code text NOT NULL
);


ALTER TABLE public.owner OWNER TO postgres;

--
-- TOC entry 198 (class 1259 OID 16484)
-- Name: transaction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transaction (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    "time" timestamp with time zone,
    message text
);


ALTER TABLE public.transaction OWNER TO postgres;

--
-- TOC entry 200 (class 1259 OID 16502)
-- Name: transactionlog; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transactionlog (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    transaction_id uuid,
    type text,
    amount numeric(8,0),
    amount_type text,
    account_id uuid
);


ALTER TABLE public.transactionlog OWNER TO postgres;

--
-- TOC entry 3173 (class 0 OID 16493)
-- Dependencies: 199
-- Data for Name: currencyaccount; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.currencyaccount (id, owner, currency) FROM stdin;
d0840394-5ed2-46db-807a-7a5ca9c8924a	ea5566fc-9e76-466c-936d-ad483385a8c8	Iron Ore
d1ae5ed1-b0d9-4252-9a41-70dbc392670b	dda0575c-8e04-4645-9cc1-8aabed9fd9b1	Iron Ore
eaa2d4ef-c0ae-4c3d-bd6a-0d23511ae021	dda0575c-8e04-4645-9cc1-8aabed9fd9b1	Gold Ore
6ac62ca8-10e9-4c77-b8b3-2bbcfe5379f0	dda0575c-8e04-4645-9cc1-8aabed9fd9b1	Iron Bar
1a006b27-32cf-4d20-a935-83ad05037b45	dda0575c-8e04-4645-9cc1-8aabed9fd9b1	Gold Bar
379b6fba-97fe-4c89-9b80-6c3eeb969bc7	89604646-2606-4f0b-a620-d9932bddbe6c	Gold Ore
202dc9a6-a06e-4284-91eb-0e8a40933e82	25e6ffb8-eda4-4877-adf2-4d3d03dce210	Iron Bar
990d5771-5863-4e95-98aa-403b5a56ecf9	25e6ffb8-eda4-4877-adf2-4d3d03dce210	Gold Bar
07568164-b94c-4628-99bf-b7cb6781cdbc	25e6ffb8-eda4-4877-adf2-4d3d03dce210	Aluminum
f1c3c13e-e307-401e-8402-903005b84e12	12f2d34f-57bd-4d2c-bcb5-52a550300e3e	Phone frame
7dbcfb65-1200-4de2-9e30-68b98c17f8af	12f2d34f-57bd-4d2c-bcb5-52a550300e3e	Motherboard
1fae693a-ea3f-4fb7-81ec-4f7a805117a6	12f2d34f-57bd-4d2c-bcb5-52a550300e3e	Heat conductor
0507a9a8-207e-4fe9-96ec-38f93d34de1a	12f2d34f-57bd-4d2c-bcb5-52a550300e3e	Phone frame
ad4566d4-52d4-4994-879c-8f93d4d272a1	12f2d34f-57bd-4d2c-bcb5-52a550300e3e	Motherboard
75174e9e-7dbd-4dfe-b4d5-d875ffb49d2c	12f2d34f-57bd-4d2c-bcb5-52a550300e3e	Heat conductor
ca0353e0-91b1-4760-9ef4-3b706c1c6932	12f2d34f-57bd-4d2c-bcb5-52a550300e3e	Phone
c0f155a4-2f23-4ca4-8371-536c844a7162	0ab57b5a-44cf-429d-ac8e-f665e9cdfd9b	Phone
be0d47b8-e390-4d25-a4b5-03c57bd30228	2beb0b7e-05c4-4108-8270-a76062ad98de	Phone
5011b74a-5d96-487b-bd38-b4fff0c352d4	f49dddac-6e79-43bf-be9a-b80ed5f96c27	Alumina
009e1cb9-a69d-4d26-ac0a-50a169ae3ec1	f49dddac-6e79-43bf-be9a-b80ed5f96c27	Aluminum
\.


--
-- TOC entry 3171 (class 0 OID 16466)
-- Dependencies: 197
-- Data for Name: owner; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.owner (id, name, country_code) FROM stdin;
ea5566fc-9e76-466c-936d-ad483385a8c8	Iron Mine	SE
dda0575c-8e04-4645-9cc1-8aabed9fd9b1	Smeltery	SE
89604646-2606-4f0b-a620-d9932bddbe6c	Gold Mine	CN
25e6ffb8-eda4-4877-adf2-4d3d03dce210	Components LTD	CN
12f2d34f-57bd-4d2c-bcb5-52a550300e3e	Phone Manufacturer	CN
0ab57b5a-44cf-429d-ac8e-f665e9cdfd9b	Phone Company	US
2beb0b7e-05c4-4108-8270-a76062ad98de	Reseller	US
f49dddac-6e79-43bf-be9a-b80ed5f96c27	Aluminum Smeltery	CN
\.


--
-- TOC entry 3172 (class 0 OID 16484)
-- Dependencies: 198
-- Data for Name: transaction; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transaction (id, "time", message) FROM stdin;
08842734-38b9-426c-b20a-f78f3f6f27f3	2018-01-01 16:00:00+01	Melted 2 tonnes of Iron Ore into Iron Bars
fb40faaf-4519-4550-bc20-85cd22d775e9	2017-10-10 16:00:00+02	Mined 10 tonnes of Iron ore
70667bbb-1931-42df-b643-95ea9a39ffdc	2017-10-27 14:00:00+02	Shipped 5 tonnes of Iron ore
b682e9ab-bde8-41f8-a027-3941937f54cc	2018-01-10 11:00:00+01	Shipped 1.5 tonnes of Iron bars
94e18dd6-feac-4bcc-87f3-705128acd509	2018-03-10 10:00:00+01	Converted 1.3 tonnes of iron into frame components
d67bcbf1-d55e-4f1e-8772-6fe28b50dfb9	2018-03-11 11:00:00+01	Converted 200 kg of iron into motherboards
1744c04e-f9ee-46ba-9002-ee137c3ad603	2018-01-10 16:00:00+01	Mined 100 kg of gold ore
28c7e62b-682f-4199-94ff-1cb235a676d8	2018-01-11 19:00:00+01	shipped 100 kg of gold ore
aa24925b-6c0f-493b-a21c-c5b316ed24ee	2018-01-13 16:00:00+01	melted 100 kg of gold ore into bars
fa662ef2-9cd3-415e-b94b-a5223c502fc0	2018-01-14 12:00:00+01	shipped 98 kg of gold bars
ab6638df-2a6c-4288-983a-0ba47b6b3ab8	2018-02-19 16:00:00+01	Created 100k heatconductors from 98 kg gold
7bf92e07-714f-4064-92b2-13e8de938ec7	2018-02-10 11:00:00+01	Created 6 tonnes of aluminum from alumina
b3f5bf08-d9dd-4479-8c54-5bc4bc942880	2018-04-10 12:00:00+02	Created 120k framepars from 4 tonnes of alu
9c6bda8b-969b-4d99-80a9-f4d01aa373f7	2018-04-01 16:00:00+02	Created 150k motherboard parts from 2 tonnes alu
a0575775-a824-43a9-bea3-ba8d64103a45	2018-05-10 16:00:00+02	Assembled 100k frames
580bfc40-e505-4eda-992d-9efeacca9f9a	2018-06-01 01:00:00+02	Assembled 100k phones
d176cec0-d372-47fe-9913-e3bcc47ca357	2018-06-20 16:00:00+02	Shipped 100k phone
31250894-7eba-47a1-8bfb-060edd2f709c	2018-07-01 16:00:00+02	Shipped 100k phone
f0cf1693-fe76-4397-8cd0-56f8023db72c	2018-07-10 16:00:00+02	Shipped 1 phone
\.


--
-- TOC entry 3174 (class 0 OID 16502)
-- Dependencies: 200
-- Data for Name: transactionlog; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transactionlog (id, transaction_id, type, amount, amount_type, account_id) FROM stdin;
d09e6c6a-a707-468b-bbdd-94322b29cfaf	08842734-38b9-426c-b20a-f78f3f6f27f3	debit	2000	Kg	d1ae5ed1-b0d9-4252-9a41-70dbc392670b
909c6b45-e2c9-45f0-a210-c273f9ca1d9d	08842734-38b9-426c-b20a-f78f3f6f27f3	credit	2000	Kg	6ac62ca8-10e9-4c77-b8b3-2bbcfe5379f0
aec725b9-9462-4a58-b72a-32a5db4de42d	fb40faaf-4519-4550-bc20-85cd22d775e9	credit	10000	kg	d0840394-5ed2-46db-807a-7a5ca9c8924a
035b383a-2557-44d2-afb6-c0ca64065a23	70667bbb-1931-42df-b643-95ea9a39ffdc	debit	5000	kg	d0840394-5ed2-46db-807a-7a5ca9c8924a
ebb9b180-eb59-4476-ac8a-c14f7fabde88	70667bbb-1931-42df-b643-95ea9a39ffdc	credit	5000	kg	d1ae5ed1-b0d9-4252-9a41-70dbc392670b
9090984a-9dfa-49f4-9dbf-6afb1e52a553	b682e9ab-bde8-41f8-a027-3941937f54cc	debit	1500	kg	6ac62ca8-10e9-4c77-b8b3-2bbcfe5379f0
9eca4333-89c2-485a-9728-904df8e57c3e	b682e9ab-bde8-41f8-a027-3941937f54cc	credit	1500	kg	202dc9a6-a06e-4284-91eb-0e8a40933e82
343b1125-442b-46ce-a9e0-eab51046dc0e	94e18dd6-feac-4bcc-87f3-705128acd509	debit	1300	kg	202dc9a6-a06e-4284-91eb-0e8a40933e82
b991cb61-4f92-49c4-8e8b-9da169bd0e2f	94e18dd6-feac-4bcc-87f3-705128acd509	credit	1300	kg	f1c3c13e-e307-401e-8402-903005b84e12
\.


--
-- TOC entry 3047 (class 2606 OID 16501)
-- Name: currencyaccount currencyaccount_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.currencyaccount
    ADD CONSTRAINT currencyaccount_pkey PRIMARY KEY (id);


--
-- TOC entry 3043 (class 2606 OID 16474)
-- Name: owner owner_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.owner
    ADD CONSTRAINT owner_pkey PRIMARY KEY (id);


--
-- TOC entry 3045 (class 2606 OID 16492)
-- Name: transaction transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT transaction_pkey PRIMARY KEY (id);


--
-- TOC entry 3049 (class 2606 OID 16510)
-- Name: transactionlog transactionlog_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactionlog
    ADD CONSTRAINT transactionlog_pkey PRIMARY KEY (id);


-- Completed on 2019-09-17 16:20:13 CEST

--
-- PostgreSQL database dump complete
--

