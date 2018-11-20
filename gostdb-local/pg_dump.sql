--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.5
-- Dumped by pg_dump version 9.6.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: tiger; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tiger;


ALTER SCHEMA tiger OWNER TO postgres;

--
-- Name: tiger_data; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tiger_data;


ALTER SCHEMA tiger_data OWNER TO postgres;

--
-- Name: topology; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO postgres;

--
-- Name: v1; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA v1;


ALTER SCHEMA v1 OWNER TO postgres;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- Name: postgis_tiger_geocoder; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder WITH SCHEMA tiger;


--
-- Name: EXTENSION postgis_tiger_geocoder; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_tiger_geocoder IS 'PostGIS tiger geocoder and reverse geocoder';


--
-- Name: postgis_topology; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;


--
-- Name: EXTENSION postgis_topology; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_topology IS 'PostGIS topology spatial types and functions';


SET search_path = v1, pg_catalog;

--
-- Name: delete_coupled_historicallocation(); Type: FUNCTION; Schema: v1; Owner: postgres
--

CREATE FUNCTION delete_coupled_historicallocation() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
 DELETE FROM v1.historicallocation WHERE id = OLD.historicallocation_id;
 RETURN NEW;
END$$;


ALTER FUNCTION v1.delete_coupled_historicallocation() OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: datastream; Type: TABLE; Schema: v1; Owner: postgres
--

CREATE TABLE datastream (
    id bigint NOT NULL,
    name character varying(255),
    description character varying(500),
    unitofmeasurement jsonb,
    observationtype integer,
    observedarea public.geometry(Geometry,4326),
    phenomenontime tstzrange,
    resulttime tstzrange,
    thing_id bigint,
    sensor_id bigint,
    observedproperty_id bigint
);


ALTER TABLE datastream OWNER TO postgres;

--
-- Name: datastream_id_seq; Type: SEQUENCE; Schema: v1; Owner: postgres
--

CREATE SEQUENCE datastream_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE datastream_id_seq OWNER TO postgres;

--
-- Name: datastream_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: postgres
--

ALTER SEQUENCE datastream_id_seq OWNED BY datastream.id;


--
-- Name: featureofinterest; Type: TABLE; Schema: v1; Owner: postgres
--

CREATE TABLE featureofinterest (
    id bigint NOT NULL,
    name character varying(255),
    description character varying(500),
    encodingtype integer,
    feature public.geometry(Geometry,4326),
    original_location_id bigint
);


ALTER TABLE featureofinterest OWNER TO postgres;

--
-- Name: featureofinterest_id_seq; Type: SEQUENCE; Schema: v1; Owner: postgres
--

CREATE SEQUENCE featureofinterest_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE featureofinterest_id_seq OWNER TO postgres;

--
-- Name: featureofinterest_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: postgres
--

ALTER SEQUENCE featureofinterest_id_seq OWNED BY featureofinterest.id;


--
-- Name: historicallocation; Type: TABLE; Schema: v1; Owner: postgres
--

CREATE TABLE historicallocation (
    id bigint NOT NULL,
    thing_id bigint,
    "time" timestamp with time zone
);


ALTER TABLE historicallocation OWNER TO postgres;

--
-- Name: historicallocation_id_seq; Type: SEQUENCE; Schema: v1; Owner: postgres
--

CREATE SEQUENCE historicallocation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE historicallocation_id_seq OWNER TO postgres;

--
-- Name: historicallocation_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: postgres
--

ALTER SEQUENCE historicallocation_id_seq OWNED BY historicallocation.id;


--
-- Name: location; Type: TABLE; Schema: v1; Owner: postgres
--

CREATE TABLE location (
    id bigint NOT NULL,
    name character varying(255),
    description character varying(500),
    encodingtype integer,
    location public.geometry(Geometry,4326)
);


ALTER TABLE location OWNER TO postgres;

--
-- Name: location_id_seq; Type: SEQUENCE; Schema: v1; Owner: postgres
--

CREATE SEQUENCE location_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE location_id_seq OWNER TO postgres;

--
-- Name: location_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: postgres
--

ALTER SEQUENCE location_id_seq OWNED BY location.id;


--
-- Name: location_to_historicallocation; Type: TABLE; Schema: v1; Owner: postgres
--

CREATE TABLE location_to_historicallocation (
    location_id bigint,
    historicallocation_id bigint
);


ALTER TABLE location_to_historicallocation OWNER TO postgres;

--
-- Name: observation; Type: TABLE; Schema: v1; Owner: postgres
--

CREATE TABLE observation (
    id bigint NOT NULL,
    data jsonb,
    stream_id bigint,
    featureofinterest_id bigint
);


ALTER TABLE observation OWNER TO postgres;

--
-- Name: observation_id_seq; Type: SEQUENCE; Schema: v1; Owner: postgres
--

CREATE SEQUENCE observation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE observation_id_seq OWNER TO postgres;

--
-- Name: observation_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: postgres
--

ALTER SEQUENCE observation_id_seq OWNED BY observation.id;


--
-- Name: observedproperty; Type: TABLE; Schema: v1; Owner: postgres
--

CREATE TABLE observedproperty (
    id bigint NOT NULL,
    name character varying(120),
    definition character varying(255),
    description character varying(500)
);


ALTER TABLE observedproperty OWNER TO postgres;

--
-- Name: observedproperty_id_seq; Type: SEQUENCE; Schema: v1; Owner: postgres
--

CREATE SEQUENCE observedproperty_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE observedproperty_id_seq OWNER TO postgres;

--
-- Name: observedproperty_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: postgres
--

ALTER SEQUENCE observedproperty_id_seq OWNED BY observedproperty.id;


--
-- Name: sensor; Type: TABLE; Schema: v1; Owner: postgres
--

CREATE TABLE sensor (
    id bigint NOT NULL,
    name character varying(255),
    description character varying(500),
    encodingtype integer,
    metadata text
);


ALTER TABLE sensor OWNER TO postgres;

--
-- Name: sensor_id_seq; Type: SEQUENCE; Schema: v1; Owner: postgres
--

CREATE SEQUENCE sensor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sensor_id_seq OWNER TO postgres;

--
-- Name: sensor_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: postgres
--

ALTER SEQUENCE sensor_id_seq OWNED BY sensor.id;


--
-- Name: thing; Type: TABLE; Schema: v1; Owner: postgres
--

CREATE TABLE thing (
    id bigint NOT NULL,
    name character varying(255),
    description character varying(500),
    properties jsonb
);


ALTER TABLE thing OWNER TO postgres;

--
-- Name: thing_id_seq; Type: SEQUENCE; Schema: v1; Owner: postgres
--

CREATE SEQUENCE thing_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE thing_id_seq OWNER TO postgres;

--
-- Name: thing_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: postgres
--

ALTER SEQUENCE thing_id_seq OWNED BY thing.id;


--
-- Name: thing_to_location; Type: TABLE; Schema: v1; Owner: postgres
--

CREATE TABLE thing_to_location (
    thing_id bigint,
    location_id bigint
);


ALTER TABLE thing_to_location OWNER TO postgres;

--
-- Name: datastream id; Type: DEFAULT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY datastream ALTER COLUMN id SET DEFAULT nextval('datastream_id_seq'::regclass);


--
-- Name: featureofinterest id; Type: DEFAULT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY featureofinterest ALTER COLUMN id SET DEFAULT nextval('featureofinterest_id_seq'::regclass);


--
-- Name: historicallocation id; Type: DEFAULT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY historicallocation ALTER COLUMN id SET DEFAULT nextval('historicallocation_id_seq'::regclass);


--
-- Name: location id; Type: DEFAULT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY location ALTER COLUMN id SET DEFAULT nextval('location_id_seq'::regclass);


--
-- Name: observation id; Type: DEFAULT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY observation ALTER COLUMN id SET DEFAULT nextval('observation_id_seq'::regclass);


--
-- Name: observedproperty id; Type: DEFAULT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY observedproperty ALTER COLUMN id SET DEFAULT nextval('observedproperty_id_seq'::regclass);


--
-- Name: sensor id; Type: DEFAULT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY sensor ALTER COLUMN id SET DEFAULT nextval('sensor_id_seq'::regclass);


--
-- Name: thing id; Type: DEFAULT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY thing ALTER COLUMN id SET DEFAULT nextval('thing_id_seq'::regclass);


SET search_path = public, pg_catalog;

--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


SET search_path = tiger, pg_catalog;

--
-- Data for Name: geocode_settings; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY geocode_settings (name, setting, unit, category, short_desc) FROM stdin;
\.


--
-- Data for Name: pagc_gaz; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY pagc_gaz (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: pagc_lex; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY pagc_lex (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: pagc_rules; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY pagc_rules (id, rule, is_custom) FROM stdin;
\.


SET search_path = topology, pg_catalog;

--
-- Data for Name: topology; Type: TABLE DATA; Schema: topology; Owner: postgres
--

COPY topology (id, name, srid, "precision", hasz) FROM stdin;
\.


--
-- Data for Name: layer; Type: TABLE DATA; Schema: topology; Owner: postgres
--

COPY layer (topology_id, layer_id, schema_name, table_name, feature_column, feature_type, level, child_id) FROM stdin;
\.


SET search_path = v1, pg_catalog;

--
-- Data for Name: datastream; Type: TABLE DATA; Schema: v1; Owner: postgres
--

COPY datastream (id, name, description, unitofmeasurement, observationtype, observedarea, phenomenontime, resulttime, thing_id, sensor_id, observedproperty_id) FROM stdin;
2	Filament Skidrate DS	Skid rate per unit length at feeding time.	{"name": "Units per meter", "symbol": "1/m", "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#PerMeter"}	3	\N	\N	\N	1	1	2
3	Skid Count DS	Cumulated number of skids, which occurred during a specific print	{"name": "Counting Unit", "symbol": "1", "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#Number"}	3	\N	\N	\N	1	1	3
4	Ambient Temperature DS	Observations of temperature of surrounding during print.	{"name": "Degree Celsius", "symbol": "degC", "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#DegreeCelsius"}	3	\N	\N	\N	1	2	4
5	Bed Temperature DS	Observations of temperature of base plate during print.	{"name": "Degree Celsius", "symbol": "degC", "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#DegreeCelsius"}	3	\N	\N	\N	1	3	5
6	Nozzle Temperature DS	Observations of temperature of nozzle during print.	{"name": "Degree Celsius", "symbol": "degC", "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#DegreeCelsius"}	3	\N	\N	\N	1	4	6
7	Airquality DS	Observations of airquality during print.	{"name": "Volatile Organic Compounds", "symbol": "VOC", "definition": "https://en.wikipedia.org/wiki/Volatile_organic_compound"}	3	\N	\N	\N	1	5	7
8	Printer Head Z-Coordinate DS	Observations of z-coordinate of printer head.	{"name": "Milimeter", "symbol": "mm", "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#MilliM"}	3	\N	\N	\N	1	6	8
9	Filament Usage DS	Observations used filament during print	{"name": "Cubic Milimeter", "symbol": "mm3", "definition": "http://qudt.org/vocab/unit/MilliM3"}	3	\N	\N	\N	1	7	9
10	Temp321	wall left-back-top	{"name": "Degree Celsius", "symbol": "degC", "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#DegreeCelsius"}	3	\N	\N	\N	1	8	10
11	Temp211	wall left-front-top	{"name": "Degree Celsius", "symbol": "degC", "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#DegreeCelsius"}	3	\N	\N	\N	1	8	11
12	Temp111	wall right-back-top	{"name": "Degree Celsius", "symbol": "degC", "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#DegreeCelsius"}	3	\N	\N	\N	1	8	12
13	Temp412	wall right-front-top	{"name": "Degree Celsius", "symbol": "degC", "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#DegreeCelsius"}	3	\N	\N	\N	1	8	13
14	Temp212	wall left-back-bottom	{"name": "Degree Celsius", "symbol": "degC", "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#DegreeCelsius"}	3	\N	\N	\N	1	8	14
15	Temp311	wall left-front-bottom	{"name": "Degree Celsius", "symbol": "degC", "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#DegreeCelsius"}	3	\N	\N	\N	1	8	15
16	Temp411	wall right-back-bottom	{"name": "Degree Celsius", "symbol": "degC", "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#DegreeCelsius"}	3	\N	\N	\N	1	8	16
17	Temp121	wall right-front-top	{"name": "Degree Celsius", "symbol": "degC", "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#DegreeCelsius"}	3	\N	\N	\N	1	8	17
18	Temp312	wall left-middle-middle	{"name": "Degree Celsius", "symbol": "degC", "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#DegreeCelsius"}	3	\N	\N	\N	1	8	18
19	Temp122	wall right-middle-middle	{"name": "Degree Celsius", "symbol": "degC", "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#DegreeCelsius"}	3	\N	\N	\N	1	8	19
20	Temp512	print bed-back-left	{"name": "Degree Celsius", "symbol": "degC", "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#DegreeCelsius"}	3	\N	\N	\N	1	8	20
21	Temp511	print-bed back-middle	{"name": "Degree Celsius", "symbol": "degC", "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#DegreeCelsius"}	3	\N	\N	\N	1	8	21
22	Temp621	print-bed back-right	{"name": "Degree Celsius", "symbol": "degC", "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#DegreeCelsius"}	3	\N	\N	\N	1	8	22
23	Temp421	print-bed middle-left	{"name": "Degree Celsius", "symbol": "degC", "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#DegreeCelsius"}	3	\N	\N	\N	1	8	23
24	Temp622	print-bed middle-right	{"name": "Degree Celsius", "symbol": "degC", "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#DegreeCelsius"}	3	\N	\N	\N	1	8	24
25	Temp422	print-bed front-left	{"name": "Degree Celsius", "symbol": "degC", "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#DegreeCelsius"}	3	\N	\N	\N	1	8	25
26	Temp612	print-bed front-middle	{"name": "Degree Celsius", "symbol": "degC", "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#DegreeCelsius"}	3	\N	\N	\N	1	8	26
27	Temp611	print-bed front-right	{"name": "Degree Celsius", "symbol": "degC", "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#DegreeCelsius"}	3	\N	\N	\N	1	8	27
28	Temp322	stepper-motor-y-axis	{"name": "Degree Celsius", "symbol": "degC", "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#DegreeCelsius"}	3	\N	\N	\N	1	8	28
29	Temp112	stepper-motor-x-axis	{"name": "Degree Celsius", "symbol": "degC", "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#DegreeCelsius"}	3	\N	\N	\N	1	8	29
30	TimeRemaining	Alert outlining potential failure within a given time	{"name": "TimeRemaining", "symbol": "ipn.TimeRemaining", "definition": "text,confidence,remainingTime,quality"}	4	\N	\N	\N	1	9	30
1	Filament Usage DS	Distance of used filament, Cumulated in the current print	{"name": "Milimeter", "symbol": "mm", "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#MilliM"}	3	\N	\N	\N	1	1	1
34	Filament Throughput DS	Filament Throughput in mm^3/s	{"name": "Cubic Millimeter per Second", "symbol": "mm3/s", "definition": "http://www.qudt.org/qudt/owl/1.0.0/quantity/index.html#VolumePerUnitTime"}	3	\N	\N	\N	1	1	33
32	Printing Status DS	Detection if the Printer is busy, this metric origins from the 3D Printer and is gathered by the controller il030. Mapping: {0: off, 1: on}	{"name": "Binary Unit", "symbol": "1", "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#BinaryPrefixUnit"}	3	\N	\N	\N	1	1	32
31	Filament Movement DS	Detection of a filament movement. Mapping: {0: no movement, 1: movement}	{"name": "Binary Unit", "symbol": "1", "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#BinaryPrefixUnit"}	3	\N	\N	\N	1	1	31
35	3DPrinterFilamentChange	The type and color of filament which is used by the 3D printer	{"name": "3D Printer Filament", "symbol": "srfg.3DPrinterFilament", "defitintion": "filament string"}	4	\N	\N	\N	1	10	35
36	3DPrintAnnotations	Annotations of the latest print.	{"name": "3D Print Annotation", "symbol": "srfg.3DPrintAnnotations", "defitintion": "annotation string"}	4	\N	\N	\N	1	10	36
37	3DPrinterNozzleCleansing	The nozzle of the 3D printer was cleaned	{"name": "eventFlag", "symbol": "srfg.3DPrinterNozzleCleansing", "defitintion": "the event triggers a 1 flag"}	4	\N	\N	\N	1	10	37
\.


--
-- Name: datastream_id_seq; Type: SEQUENCE SET; Schema: v1; Owner: postgres
--

SELECT pg_catalog.setval('datastream_id_seq', 37, true);


--
-- Data for Name: featureofinterest; Type: TABLE DATA; Schema: v1; Owner: postgres
--

COPY featureofinterest (id, name, description, encodingtype, feature, original_location_id) FROM stdin;
\.


--
-- Name: featureofinterest_id_seq; Type: SEQUENCE SET; Schema: v1; Owner: postgres
--

SELECT pg_catalog.setval('featureofinterest_id_seq', 1, true);


--
-- Data for Name: historicallocation; Type: TABLE DATA; Schema: v1; Owner: postgres
--

COPY historicallocation (id, thing_id, "time") FROM stdin;
\.


--
-- Name: historicallocation_id_seq; Type: SEQUENCE SET; Schema: v1; Owner: postgres
--

SELECT pg_catalog.setval('historicallocation_id_seq', 1, false);


--
-- Data for Name: location; Type: TABLE DATA; Schema: v1; Owner: postgres
--

COPY location (id, name, description, encodingtype, location) FROM stdin;
\.


--
-- Name: location_id_seq; Type: SEQUENCE SET; Schema: v1; Owner: postgres
--

SELECT pg_catalog.setval('location_id_seq', 1, false);


--
-- Data for Name: location_to_historicallocation; Type: TABLE DATA; Schema: v1; Owner: postgres
--

COPY location_to_historicallocation (location_id, historicallocation_id) FROM stdin;
\.


--
-- Data for Name: observation; Type: TABLE DATA; Schema: v1; Owner: postgres
--

COPY observation (id, data, stream_id, featureofinterest_id) FROM stdin;
\.


--
-- Name: observation_id_seq; Type: SEQUENCE SET; Schema: v1; Owner: postgres
--

SELECT pg_catalog.setval('observation_id_seq', 1, false);


--
-- Data for Name: observedproperty; Type: TABLE DATA; Schema: v1; Owner: postgres
--

COPY observedproperty (id, name, definition, description) FROM stdin;
1	Filament Length	http://www.qudt.org/qudt/owl/1.0.0/quantity/Instances.html#Length	Distance of fed filament
2	Skidrate of Filament	http://www.qudt.org/qudt/owl/1.0.0/quantity/Instances.html#InverseLength	Rate of skids per unit length, smoothed over 0.1 meter
3	Skid Count	http://www.qudt.org/qudt/owl/1.0.0/quantity/Instances.html#Dimensionless	Cumulated number of skids, which occurred during a specific print
4	Ambient Temperature	http://www.qudt.org/qudt/owl/1.0.0/quantity/Instances.html#ThermodynamicTemperature	Temperature of surrounding during print.
5	Bed Temperature	http://www.qudt.org/qudt/owl/1.0.0/quantity/Instances.html#ThermodynamicTemperature	Temperature of base plate during print.
6	Nozzle Temperature	http://www.qudt.org/qudt/owl/1.0.0/quantity/Instances.html#ThermodynamicTemperature	Temperature of nozzle during print.
7	Airquality	https://en.wikipedia.org/wiki/Volatile_organic_compound	Quality of air during print.
8	Printer Head Z-Coordinate	http://www.qudt.org/qudt/owl/1.0.0/quantity/Instances.html#Length	Z-Coordinate of printer head.
9	Filament Usage	http://www.qudt.org/qudt/owl/1.0.0/quantity/Instances.html#Volume	Volume of used filament
10	Temperature	http://www.qudt.org/qudt/owl/1.0.0/quantity/Instances.html#ThermodynamicTemperature	wall left-back-top
11	Temperature	http://www.qudt.org/qudt/owl/1.0.0/quantity/Instances.html#ThermodynamicTemperature	wall left-front-top
12	Temperature	http://www.qudt.org/qudt/owl/1.0.0/quantity/Instances.html#ThermodynamicTemperature	wall right-back-top
13	Temperature	http://www.qudt.org/qudt/owl/1.0.0/quantity/Instances.html#ThermodynamicTemperature	wall right-front-top
14	Temperature	http://www.qudt.org/qudt/owl/1.0.0/quantity/Instances.html#ThermodynamicTemperature	wall left-back-bottom
15	Temperature	http://www.qudt.org/qudt/owl/1.0.0/quantity/Instances.html#ThermodynamicTemperature	wall left-front-bottom
16	Temperature	http://www.qudt.org/qudt/owl/1.0.0/quantity/Instances.html#ThermodynamicTemperature	wall right-back-bottom
17	Temperature	http://www.qudt.org/qudt/owl/1.0.0/quantity/Instances.html#ThermodynamicTemperature	wall right-front-top
18	Temperature	http://www.qudt.org/qudt/owl/1.0.0/quantity/Instances.html#ThermodynamicTemperature	wall left-middle-middle
19	Temperature	http://www.qudt.org/qudt/owl/1.0.0/quantity/Instances.html#ThermodynamicTemperature	wall right-middle-middle
20	Temperature	http://www.qudt.org/qudt/owl/1.0.0/quantity/Instances.html#ThermodynamicTemperature	print bed-back-left
21	Temperature	http://www.qudt.org/qudt/owl/1.0.0/quantity/Instances.html#ThermodynamicTemperature	print-bed back-middle
22	Temperature	http://www.qudt.org/qudt/owl/1.0.0/quantity/Instances.html#ThermodynamicTemperature	print-bed back-right
23	Temperature	http://www.qudt.org/qudt/owl/1.0.0/quantity/Instances.html#ThermodynamicTemperature	print-bed middle-left
24	Temperature	http://www.qudt.org/qudt/owl/1.0.0/quantity/Instances.html#ThermodynamicTemperature	print-bed middle-right
25	Temperature	http://www.qudt.org/qudt/owl/1.0.0/quantity/Instances.html#ThermodynamicTemperature	print-bed front-left
26	Temperature	http://www.qudt.org/qudt/owl/1.0.0/quantity/Instances.html#ThermodynamicTemperature	print-bed front-middle
27	Temperature	http://www.qudt.org/qudt/owl/1.0.0/quantity/Instances.html#ThermodynamicTemperature	print-bed front-right
28	Temperature	http://www.qudt.org/qudt/owl/1.0.0/quantity/Instances.html#ThermodynamicTemperature	stepper-motor-y-axis
29	Temperature	http://www.qudt.org/qudt/owl/1.0.0/quantity/Instances.html#ThermodynamicTemperature	stepper-motor-x-axis
30	Lifetime	http://www.predictive.at/maintenance/lifetime	Denotes the (remaining) lifetime of a particular thing
31	Filament Movement	http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#BinaryPrefixUnit	Detection of a filament movement
32	Printing Status	http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#BinaryPrefixUnit	Detection if the Printer is busy
33	Filament Throughput	http://www.qudt.org/qudt/owl/1.0.0/quantity/index.html#VolumePerUnitTime	Filament Throughput in mm^3/s
35	3D Printer Filament Type	http://il050:6789/edit_filaments	The type of filament used by the printer
36	3D Prints annotation	http://il050:6789/definition_annotation	Annotations of the latest prints
37	3D Printer Nozzle Cleansing	http://il050:6789/nozzle_cleanings	A cleaning of the nozzle occured
\.


--
-- Name: observedproperty_id_seq; Type: SEQUENCE SET; Schema: v1; Owner: postgres
--

SELECT pg_catalog.setval('observedproperty_id_seq', 37, true);


--
-- Data for Name: sensor; Type: TABLE DATA; Schema: v1; Owner: postgres
--

COPY sensor (id, name, description, encodingtype, metadata) FROM stdin;
1	Filament Sensor	The Filament Sensor measures the filament feeding process of the Ultimaker 2 3D printer by using the X4-encoding	2	https://www.thingiverse.com/thing:1733104
2	Air temperature sensor	NTC temperature sensor for air	2	https://shop.bb-sensors.com/out/media/Datasheet_NTC%20Sensor_0365%200020-12.pdf
3	Ultimaker 2 internal Temperature Sensor	The Ultimaker 2 is featured with internal PT100 sensors	2	https://ultimaker.com/file/download/productgroup/Ultimaker%202+%20specification%20sheet.pdf/5819be416ae76.pdf
4	Ultimaker 2 internal Nozzle Temperature Sensor	The Ultimaker 2 is featured with internal PT100 sensor	2	https://ultimaker.com/file/download/productgroup/Ultimaker%202+%20specification%20sheet.pdf/5819be416ae76.pdf
5	VELUX Raumluftfuehler	Messung der Raumluftqualitaet auf Basis fluechtiger organischer Verbindungen (VOCs).	2	http://www.velux.de/produkte/lueftungsloesungen-belueftung/raumluftfuehler
6	Print Head position Z	Print Head position Z-axis (height)	2	https://ultimaker.com/file/download/productgroup/Ultimaker%202+%20specification%20sheet.pdf/5819be416ae76.pdf
7	Planned Filament Extrusion	Volume of Filament feeded by the printer	2	https://ultimaker.com/file/download/productgroup/Ultimaker%202+%20specification%20sheet.pdf/5819be416ae76.pdf
8	LM35	Temperature Sensor with Analog Output with 30V Capability	2	http://www.ti.com/lit/gpn/LM35
9	IPN	Predictive Maintenance Alerts	2	http://wwww.ipn.com
10	3DPrintOperatorDashboard	Interactions from the Operator Dashboard made by the operator.	2	http://il050:6789/dashboard
\.


--
-- Name: sensor_id_seq; Type: SEQUENCE SET; Schema: v1; Owner: postgres
--

SELECT pg_catalog.setval('sensor_id_seq', 11, true);


--
-- Data for Name: thing; Type: TABLE DATA; Schema: v1; Owner: postgres
--

COPY thing (id, name, description, properties) FROM stdin;
1	Ultimaker 2	3D printer Ultimaker 2 in IoT Lab	{"kafka": {"hosts": ["il061:9092", "il062:9092", "il063:9092"], "topics": {"alert": "Malfunctions", "sensor": "SensorData", "operations": "OperatorData"}}, "isprong_uuid": "77371300-a534-4416-a640-39c559c34e13", "specification": "https://ultimaker.com/file/download/productgroup/Ultimaker%202+%20specification%20sheet.pdf/5819be416ae76.pdf"}
\.


--
-- Name: thing_id_seq; Type: SEQUENCE SET; Schema: v1; Owner: postgres
--

SELECT pg_catalog.setval('thing_id_seq', 1, true);


--
-- Data for Name: thing_to_location; Type: TABLE DATA; Schema: v1; Owner: postgres
--

COPY thing_to_location (thing_id, location_id) FROM stdin;
\.


--
-- Name: datastream datastream_pkey; Type: CONSTRAINT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY datastream
    ADD CONSTRAINT datastream_pkey PRIMARY KEY (id);


--
-- Name: featureofinterest featureofinterest_pkey; Type: CONSTRAINT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY featureofinterest
    ADD CONSTRAINT featureofinterest_pkey PRIMARY KEY (id);


--
-- Name: historicallocation historicallocation_pkey; Type: CONSTRAINT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY historicallocation
    ADD CONSTRAINT historicallocation_pkey PRIMARY KEY (id);


--
-- Name: location location_pkey; Type: CONSTRAINT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY location
    ADD CONSTRAINT location_pkey PRIMARY KEY (id);


--
-- Name: observation observation_pkey; Type: CONSTRAINT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY observation
    ADD CONSTRAINT observation_pkey PRIMARY KEY (id);


--
-- Name: observedproperty observedproperty_pkey; Type: CONSTRAINT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY observedproperty
    ADD CONSTRAINT observedproperty_pkey PRIMARY KEY (id);


--
-- Name: sensor sensor_pkey; Type: CONSTRAINT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY sensor
    ADD CONSTRAINT sensor_pkey PRIMARY KEY (id);


--
-- Name: thing thing_pkey; Type: CONSTRAINT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY thing
    ADD CONSTRAINT thing_pkey PRIMARY KEY (id);


--
-- Name: fki_datastream; Type: INDEX; Schema: v1; Owner: postgres
--

CREATE INDEX fki_datastream ON observation USING btree (stream_id);


--
-- Name: fki_featureofinterest; Type: INDEX; Schema: v1; Owner: postgres
--

CREATE INDEX fki_featureofinterest ON observation USING btree (featureofinterest_id);


--
-- Name: fki_historicallocation_1; Type: INDEX; Schema: v1; Owner: postgres
--

CREATE INDEX fki_historicallocation_1 ON location_to_historicallocation USING btree (historicallocation_id);


--
-- Name: fki_location_1; Type: INDEX; Schema: v1; Owner: postgres
--

CREATE INDEX fki_location_1 ON thing_to_location USING btree (location_id);


--
-- Name: fki_location_2; Type: INDEX; Schema: v1; Owner: postgres
--

CREATE INDEX fki_location_2 ON location_to_historicallocation USING btree (location_id);


--
-- Name: fki_observedproperty; Type: INDEX; Schema: v1; Owner: postgres
--

CREATE INDEX fki_observedproperty ON datastream USING btree (observedproperty_id);


--
-- Name: fki_sensor; Type: INDEX; Schema: v1; Owner: postgres
--

CREATE INDEX fki_sensor ON datastream USING btree (sensor_id);


--
-- Name: fki_thing; Type: INDEX; Schema: v1; Owner: postgres
--

CREATE INDEX fki_thing ON datastream USING btree (thing_id);


--
-- Name: fki_thing_1; Type: INDEX; Schema: v1; Owner: postgres
--

CREATE INDEX fki_thing_1 ON thing_to_location USING btree (thing_id);


--
-- Name: fki_thing_hl; Type: INDEX; Schema: v1; Owner: postgres
--

CREATE INDEX fki_thing_hl ON historicallocation USING btree (thing_id);


--
-- Name: location_to_historicallocation location_deleted; Type: TRIGGER; Schema: v1; Owner: postgres
--

CREATE TRIGGER location_deleted AFTER DELETE ON location_to_historicallocation FOR EACH ROW EXECUTE PROCEDURE delete_coupled_historicallocation();


--
-- Name: observation fk_datastream; Type: FK CONSTRAINT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY observation
    ADD CONSTRAINT fk_datastream FOREIGN KEY (stream_id) REFERENCES datastream(id) ON DELETE CASCADE;


--
-- Name: observation fk_featureofinterest; Type: FK CONSTRAINT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY observation
    ADD CONSTRAINT fk_featureofinterest FOREIGN KEY (featureofinterest_id) REFERENCES featureofinterest(id) ON DELETE CASCADE;


--
-- Name: location_to_historicallocation fk_historicallocation_1; Type: FK CONSTRAINT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY location_to_historicallocation
    ADD CONSTRAINT fk_historicallocation_1 FOREIGN KEY (historicallocation_id) REFERENCES historicallocation(id) ON DELETE CASCADE;


--
-- Name: thing_to_location fk_location_1; Type: FK CONSTRAINT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY thing_to_location
    ADD CONSTRAINT fk_location_1 FOREIGN KEY (location_id) REFERENCES location(id) ON DELETE CASCADE;


--
-- Name: location_to_historicallocation fk_location_2; Type: FK CONSTRAINT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY location_to_historicallocation
    ADD CONSTRAINT fk_location_2 FOREIGN KEY (location_id) REFERENCES location(id) ON DELETE CASCADE;


--
-- Name: datastream fk_observedproperty; Type: FK CONSTRAINT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY datastream
    ADD CONSTRAINT fk_observedproperty FOREIGN KEY (observedproperty_id) REFERENCES observedproperty(id) ON DELETE CASCADE;


--
-- Name: datastream fk_sensor; Type: FK CONSTRAINT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY datastream
    ADD CONSTRAINT fk_sensor FOREIGN KEY (sensor_id) REFERENCES sensor(id) ON DELETE CASCADE;


--
-- Name: datastream fk_thing; Type: FK CONSTRAINT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY datastream
    ADD CONSTRAINT fk_thing FOREIGN KEY (thing_id) REFERENCES thing(id) ON DELETE CASCADE;


--
-- Name: thing_to_location fk_thing_1; Type: FK CONSTRAINT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY thing_to_location
    ADD CONSTRAINT fk_thing_1 FOREIGN KEY (thing_id) REFERENCES thing(id) ON DELETE CASCADE;


--
-- Name: historicallocation fk_thing_hl; Type: FK CONSTRAINT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY historicallocation
    ADD CONSTRAINT fk_thing_hl FOREIGN KEY (thing_id) REFERENCES thing(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

