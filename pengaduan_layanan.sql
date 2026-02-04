--
-- PostgreSQL database dump
--

\restrict lC6nKb3HKJBqvXA1pWJ5cgBZhpesKEEHFEr3TEJ5OqkLailWfcvLu611w3xPU5F

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

-- Started on 2026-02-04 11:04:00

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE pengaduan_layanan;
--
-- TOC entry 5102 (class 1262 OID 16932)
-- Name: pengaduan_layanan; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE pengaduan_layanan WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';


ALTER DATABASE pengaduan_layanan OWNER TO postgres;

\unrestrict lC6nKb3HKJBqvXA1pWJ5cgBZhpesKEEHFEr3TEJ5OqkLailWfcvLu611w3xPU5F
\connect pengaduan_layanan
\restrict lC6nKb3HKJBqvXA1pWJ5cgBZhpesKEEHFEr3TEJ5OqkLailWfcvLu611w3xPU5F

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 16972)
-- Name: jenis_kelamin; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jenis_kelamin (
    id integer NOT NULL,
    nama character(1) NOT NULL
);


ALTER TABLE public.jenis_kelamin OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16971)
-- Name: jenis_kelamin_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.jenis_kelamin_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.jenis_kelamin_id_seq OWNER TO postgres;

--
-- TOC entry 5103 (class 0 OID 0)
-- Dependencies: 219
-- Name: jenis_kelamin_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.jenis_kelamin_id_seq OWNED BY public.jenis_kelamin.id;


--
-- TOC entry 236 (class 1259 OID 17087)
-- Name: keluhan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.keluhan (
    id integer NOT NULL,
    alamat text NOT NULL,
    no_hp character varying(15) NOT NULL,
    masukan text,
    pukul time without time zone NOT NULL,
    tanggal date NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.keluhan OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 17086)
-- Name: keluhan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.keluhan_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.keluhan_id_seq OWNER TO postgres;

--
-- TOC entry 5104 (class 0 OID 0)
-- Dependencies: 235
-- Name: keluhan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.keluhan_id_seq OWNED BY public.keluhan.id;


--
-- TOC entry 234 (class 1259 OID 17068)
-- Name: kuisioner; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kuisioner (
    id integer NOT NULL,
    pertanyaan_id integer,
    nilai smallint,
    profil_id integer,
    survey_date date,
    survey_time character varying(10),
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.kuisioner OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 17067)
-- Name: kuisioner_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.kuisioner_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.kuisioner_id_seq OWNER TO postgres;

--
-- TOC entry 5105 (class 0 OID 0)
-- Dependencies: 233
-- Name: kuisioner_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.kuisioner_id_seq OWNED BY public.kuisioner.id;


--
-- TOC entry 222 (class 1259 OID 16981)
-- Name: pekerjaan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pekerjaan (
    id integer NOT NULL,
    nama character varying NOT NULL
);


ALTER TABLE public.pekerjaan OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16980)
-- Name: pekerjaan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pekerjaan_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pekerjaan_id_seq OWNER TO postgres;

--
-- TOC entry 5106 (class 0 OID 0)
-- Dependencies: 221
-- Name: pekerjaan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pekerjaan_id_seq OWNED BY public.pekerjaan.id;


--
-- TOC entry 224 (class 1259 OID 16992)
-- Name: pelayanan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pelayanan (
    id integer NOT NULL,
    nama character varying
);


ALTER TABLE public.pelayanan OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16991)
-- Name: pelayanan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pelayanan_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pelayanan_id_seq OWNER TO postgres;

--
-- TOC entry 5107 (class 0 OID 0)
-- Dependencies: 223
-- Name: pelayanan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pelayanan_id_seq OWNED BY public.pelayanan.id;


--
-- TOC entry 226 (class 1259 OID 17002)
-- Name: pendidikan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pendidikan (
    id integer NOT NULL,
    nama character varying NOT NULL
);


ALTER TABLE public.pendidikan OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 17001)
-- Name: pendidikan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pendidikan_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pendidikan_id_seq OWNER TO postgres;

--
-- TOC entry 5108 (class 0 OID 0)
-- Dependencies: 225
-- Name: pendidikan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pendidikan_id_seq OWNED BY public.pendidikan.id;


--
-- TOC entry 228 (class 1259 OID 17013)
-- Name: penjamin; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.penjamin (
    id integer NOT NULL,
    nama character varying NOT NULL
);


ALTER TABLE public.penjamin OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 17012)
-- Name: penjamin_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.penjamin_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.penjamin_id_seq OWNER TO postgres;

--
-- TOC entry 5109 (class 0 OID 0)
-- Dependencies: 227
-- Name: penjamin_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.penjamin_id_seq OWNED BY public.penjamin.id;


--
-- TOC entry 230 (class 1259 OID 17024)
-- Name: pertanyaan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pertanyaan (
    id integer NOT NULL,
    deskripsi text NOT NULL
);


ALTER TABLE public.pertanyaan OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 17023)
-- Name: pertanyaan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pertanyaan_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pertanyaan_id_seq OWNER TO postgres;

--
-- TOC entry 5110 (class 0 OID 0)
-- Dependencies: 229
-- Name: pertanyaan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pertanyaan_id_seq OWNED BY public.pertanyaan.id;


--
-- TOC entry 232 (class 1259 OID 17035)
-- Name: profil; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profil (
    id integer NOT NULL,
    jenis_kelamin_id integer,
    pendidikan_id integer,
    pekerjaan_id integer,
    pelayanan_id integer,
    penjamin_id integer
);


ALTER TABLE public.profil OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 17034)
-- Name: profil_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.profil_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.profil_id_seq OWNER TO postgres;

--
-- TOC entry 5111 (class 0 OID 0)
-- Dependencies: 231
-- Name: profil_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.profil_id_seq OWNED BY public.profil.id;


--
-- TOC entry 4896 (class 2604 OID 16975)
-- Name: jenis_kelamin id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jenis_kelamin ALTER COLUMN id SET DEFAULT nextval('public.jenis_kelamin_id_seq'::regclass);


--
-- TOC entry 4905 (class 2604 OID 17090)
-- Name: keluhan id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keluhan ALTER COLUMN id SET DEFAULT nextval('public.keluhan_id_seq'::regclass);


--
-- TOC entry 4903 (class 2604 OID 17071)
-- Name: kuisioner id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kuisioner ALTER COLUMN id SET DEFAULT nextval('public.kuisioner_id_seq'::regclass);


--
-- TOC entry 4897 (class 2604 OID 16984)
-- Name: pekerjaan id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pekerjaan ALTER COLUMN id SET DEFAULT nextval('public.pekerjaan_id_seq'::regclass);


--
-- TOC entry 4898 (class 2604 OID 16995)
-- Name: pelayanan id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pelayanan ALTER COLUMN id SET DEFAULT nextval('public.pelayanan_id_seq'::regclass);


--
-- TOC entry 4899 (class 2604 OID 17005)
-- Name: pendidikan id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pendidikan ALTER COLUMN id SET DEFAULT nextval('public.pendidikan_id_seq'::regclass);


--
-- TOC entry 4900 (class 2604 OID 17016)
-- Name: penjamin id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.penjamin ALTER COLUMN id SET DEFAULT nextval('public.penjamin_id_seq'::regclass);


--
-- TOC entry 4901 (class 2604 OID 17027)
-- Name: pertanyaan id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pertanyaan ALTER COLUMN id SET DEFAULT nextval('public.pertanyaan_id_seq'::regclass);


--
-- TOC entry 4902 (class 2604 OID 17038)
-- Name: profil id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profil ALTER COLUMN id SET DEFAULT nextval('public.profil_id_seq'::regclass);


--
-- TOC entry 5080 (class 0 OID 16972)
-- Dependencies: 220
-- Data for Name: jenis_kelamin; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.jenis_kelamin (id, nama) FROM stdin;
1	L
2	P
\.


--
-- TOC entry 5096 (class 0 OID 17087)
-- Dependencies: 236
-- Data for Name: keluhan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.keluhan (id, alamat, no_hp, masukan, pukul, tanggal, created_at) FROM stdin;
1	Sidoarjo	082244567815	lama antriannya	10:52:00	2026-02-04	2026-02-04 10:52:34.212533
\.


--
-- TOC entry 5094 (class 0 OID 17068)
-- Dependencies: 234
-- Data for Name: kuisioner; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kuisioner (id, pertanyaan_id, nilai, profil_id, survey_date, survey_time, created_at) FROM stdin;
1	4	4	5	2026-02-03	12-18	2026-02-03 20:21:04.5507
2	5	4	5	2026-02-03	12-18	2026-02-03 20:21:04.553953
3	6	4	5	2026-02-03	12-18	2026-02-03 20:21:04.554319
4	7	4	5	2026-02-03	12-18	2026-02-03 20:21:04.554601
5	8	4	5	2026-02-03	12-18	2026-02-03 20:21:04.554919
6	9	4	5	2026-02-03	12-18	2026-02-03 20:21:04.555204
7	10	4	5	2026-02-03	12-18	2026-02-03 20:21:04.555467
8	11	4	5	2026-02-03	12-18	2026-02-03 20:21:04.555733
9	12	4	5	2026-02-03	12-18	2026-02-03 20:21:04.556022
10	4	1	6	2026-02-04	08-12	2026-02-04 10:09:31.123678
11	5	1	6	2026-02-04	08-12	2026-02-04 10:09:31.124722
12	6	1	6	2026-02-04	08-12	2026-02-04 10:09:31.12502
13	7	2	6	2026-02-04	08-12	2026-02-04 10:09:31.12531
14	8	4	6	2026-02-04	08-12	2026-02-04 10:09:31.125621
15	9	3	6	2026-02-04	08-12	2026-02-04 10:09:31.125992
16	10	3	6	2026-02-04	08-12	2026-02-04 10:09:31.126484
17	11	3	6	2026-02-04	08-12	2026-02-04 10:09:31.126762
18	12	3	6	2026-02-04	08-12	2026-02-04 10:09:31.12702
19	4	1	7	2026-02-04	10:20	2026-02-04 10:20:56.691534
20	5	2	7	2026-02-04	10:20	2026-02-04 10:20:56.693053
21	6	2	7	2026-02-04	10:20	2026-02-04 10:20:56.693399
22	7	0	7	2026-02-04	10:20	2026-02-04 10:20:56.69373
23	8	3	7	2026-02-04	10:20	2026-02-04 10:20:56.694029
24	9	3	7	2026-02-04	10:20	2026-02-04 10:20:56.694405
25	10	3	7	2026-02-04	10:20	2026-02-04 10:20:56.694725
26	11	3	7	2026-02-04	10:20	2026-02-04 10:20:56.694977
27	12	3	7	2026-02-04	10:20	2026-02-04 10:20:56.695214
\.


--
-- TOC entry 5082 (class 0 OID 16981)
-- Dependencies: 222
-- Data for Name: pekerjaan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pekerjaan (id, nama) FROM stdin;
1	PNS
2	TNI
3	POLISI
4	SWASTA
5	WIRAUSAHA
6	LAINNYA
\.


--
-- TOC entry 5084 (class 0 OID 16992)
-- Dependencies: 224
-- Data for Name: pelayanan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pelayanan (id, nama) FROM stdin;
1	ADMISI
2	GIZI
3	IGD
4	ICU
5	OPERASI
6	RADIOLOGI
7	LABORATORIUM
8	FARMASI
9	RAWAT INAP
10	RAWAT JALAN
\.


--
-- TOC entry 5086 (class 0 OID 17002)
-- Dependencies: 226
-- Data for Name: pendidikan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pendidikan (id, nama) FROM stdin;
1	SD
2	SMP
3	SMA
4	S1
5	S2
6	S3
7	LAINNYA
\.


--
-- TOC entry 5088 (class 0 OID 17013)
-- Dependencies: 228
-- Data for Name: penjamin; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.penjamin (id, nama) FROM stdin;
1	UMUM
2	BPJS
\.


--
-- TOC entry 5090 (class 0 OID 17024)
-- Dependencies: 230
-- Data for Name: pertanyaan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pertanyaan (id, deskripsi) FROM stdin;
4	Bagaimana pendapat saudara tentang kesesuaian persyaratan pelayanan dengan jenis pelayanannya?
5	Bagaimana pemahaman saudara tentang kemudahan prosedur pelayanan di unit ini?
6	Bagaimana pendapat saudara tentang kecepatan waktu dalam memberikan pelayanan?
7	Bagaimana pendapat saudara tentang kewajaran biaya atau tarif dalam pelayanan? (Jika saudara peserta BPJS/Asuransi tidak perlu diisi)
8	Bagaimana pendapat saudara tentang kesesuaian produk pelayanan antara yang tercantum dalam standar pelayanan dengan hasil yang diberikan?
9	Bagaimana pendapat saudara tentang kompetensi atau kemampuan petugas dalam pelayanan?
10	Bagaimana pendapat saudara tentang perilaku petugas dalam pelayanan terkait kesopanan dan keramahan?
11	Bagaimana pendapat saudara tentang penanganan pengaduan pengguna layanan?
12	Bagaimana pendapat saudara tentang kualitas sarana dan prasarana?
\.


--
-- TOC entry 5092 (class 0 OID 17035)
-- Dependencies: 232
-- Data for Name: profil; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.profil (id, jenis_kelamin_id, pendidikan_id, pekerjaan_id, pelayanan_id, penjamin_id) FROM stdin;
4	2	3	4	7	1
5	1	5	5	6	1
1	1	2	2	2	2
2	1	2	2	2	2
3	1	2	2	2	2
6	1	4	1	2	1
7	1	1	1	2	2
\.


--
-- TOC entry 5112 (class 0 OID 0)
-- Dependencies: 219
-- Name: jenis_kelamin_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.jenis_kelamin_id_seq', 1, false);


--
-- TOC entry 5113 (class 0 OID 0)
-- Dependencies: 235
-- Name: keluhan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.keluhan_id_seq', 1, true);


--
-- TOC entry 5114 (class 0 OID 0)
-- Dependencies: 233
-- Name: kuisioner_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.kuisioner_id_seq', 27, true);


--
-- TOC entry 5115 (class 0 OID 0)
-- Dependencies: 221
-- Name: pekerjaan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pekerjaan_id_seq', 1, false);


--
-- TOC entry 5116 (class 0 OID 0)
-- Dependencies: 223
-- Name: pelayanan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pelayanan_id_seq', 1, false);


--
-- TOC entry 5117 (class 0 OID 0)
-- Dependencies: 225
-- Name: pendidikan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pendidikan_id_seq', 1, false);


--
-- TOC entry 5118 (class 0 OID 0)
-- Dependencies: 227
-- Name: penjamin_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.penjamin_id_seq', 1, false);


--
-- TOC entry 5119 (class 0 OID 0)
-- Dependencies: 229
-- Name: pertanyaan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pertanyaan_id_seq', 1, false);


--
-- TOC entry 5120 (class 0 OID 0)
-- Dependencies: 231
-- Name: profil_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.profil_id_seq', 7, true);


--
-- TOC entry 4908 (class 2606 OID 16979)
-- Name: jenis_kelamin jenis_kelamin_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jenis_kelamin
    ADD CONSTRAINT jenis_kelamin_pkey PRIMARY KEY (id);


--
-- TOC entry 4924 (class 2606 OID 17100)
-- Name: keluhan keluhan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keluhan
    ADD CONSTRAINT keluhan_pkey PRIMARY KEY (id);


--
-- TOC entry 4922 (class 2606 OID 17075)
-- Name: kuisioner kuisioner_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kuisioner
    ADD CONSTRAINT kuisioner_pkey PRIMARY KEY (id);


--
-- TOC entry 4910 (class 2606 OID 16990)
-- Name: pekerjaan pekerjaan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pekerjaan
    ADD CONSTRAINT pekerjaan_pkey PRIMARY KEY (id);


--
-- TOC entry 4912 (class 2606 OID 17000)
-- Name: pelayanan pelayanan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pelayanan
    ADD CONSTRAINT pelayanan_pkey PRIMARY KEY (id);


--
-- TOC entry 4914 (class 2606 OID 17011)
-- Name: pendidikan pendidikan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pendidikan
    ADD CONSTRAINT pendidikan_pkey PRIMARY KEY (id);


--
-- TOC entry 4916 (class 2606 OID 17022)
-- Name: penjamin penjamin_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.penjamin
    ADD CONSTRAINT penjamin_pkey PRIMARY KEY (id);


--
-- TOC entry 4918 (class 2606 OID 17033)
-- Name: pertanyaan pertanyaan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pertanyaan
    ADD CONSTRAINT pertanyaan_pkey PRIMARY KEY (id);


--
-- TOC entry 4920 (class 2606 OID 17041)
-- Name: profil profil_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profil
    ADD CONSTRAINT profil_pkey PRIMARY KEY (id);


--
-- TOC entry 4930 (class 2606 OID 17076)
-- Name: kuisioner fk_kuisioner_pertanyaan; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kuisioner
    ADD CONSTRAINT fk_kuisioner_pertanyaan FOREIGN KEY (pertanyaan_id) REFERENCES public.pertanyaan(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4931 (class 2606 OID 17081)
-- Name: kuisioner fk_kuisioner_profil; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kuisioner
    ADD CONSTRAINT fk_kuisioner_profil FOREIGN KEY (profil_id) REFERENCES public.profil(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4925 (class 2606 OID 17042)
-- Name: profil fk_profil_jenis_kelamin; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profil
    ADD CONSTRAINT fk_profil_jenis_kelamin FOREIGN KEY (jenis_kelamin_id) REFERENCES public.jenis_kelamin(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4926 (class 2606 OID 17052)
-- Name: profil fk_profil_pekerjaan; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profil
    ADD CONSTRAINT fk_profil_pekerjaan FOREIGN KEY (pekerjaan_id) REFERENCES public.pekerjaan(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4927 (class 2606 OID 17057)
-- Name: profil fk_profil_pelayanan; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profil
    ADD CONSTRAINT fk_profil_pelayanan FOREIGN KEY (pelayanan_id) REFERENCES public.pelayanan(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4928 (class 2606 OID 17047)
-- Name: profil fk_profil_pendidikan; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profil
    ADD CONSTRAINT fk_profil_pendidikan FOREIGN KEY (pendidikan_id) REFERENCES public.pendidikan(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4929 (class 2606 OID 17062)
-- Name: profil fk_profil_penjamin; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profil
    ADD CONSTRAINT fk_profil_penjamin FOREIGN KEY (penjamin_id) REFERENCES public.penjamin(id) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2026-02-04 11:04:00

--
-- PostgreSQL database dump complete
--

\unrestrict lC6nKb3HKJBqvXA1pWJ5cgBZhpesKEEHFEr3TEJ5OqkLailWfcvLu611w3xPU5F

