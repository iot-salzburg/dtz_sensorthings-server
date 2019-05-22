--
-- PostgreSQL database dump
--

-- Dumped from database version 10.5
-- Dumped by pg_dump version 10.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
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
-- Name: SCHEMA topology; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA topology IS 'PostGIS Topology schema';


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


--
-- Name: delete_coupled_historicallocation(); Type: FUNCTION; Schema: v1; Owner: postgres
--

CREATE FUNCTION v1.delete_coupled_historicallocation() RETURNS trigger
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

CREATE TABLE v1.datastream (
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


ALTER TABLE v1.datastream OWNER TO postgres;

--
-- Name: datastream_id_seq; Type: SEQUENCE; Schema: v1; Owner: postgres
--

CREATE SEQUENCE v1.datastream_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE v1.datastream_id_seq OWNER TO postgres;

--
-- Name: datastream_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: postgres
--

ALTER SEQUENCE v1.datastream_id_seq OWNED BY v1.datastream.id;


--
-- Name: featureofinterest; Type: TABLE; Schema: v1; Owner: postgres
--

CREATE TABLE v1.featureofinterest (
    id bigint NOT NULL,
    name character varying(255),
    description character varying(500),
    encodingtype integer,
    geojson jsonb,
    feature public.geometry(Geometry,4326),
    original_location_id bigint
);


ALTER TABLE v1.featureofinterest OWNER TO postgres;

--
-- Name: featureofinterest_id_seq; Type: SEQUENCE; Schema: v1; Owner: postgres
--

CREATE SEQUENCE v1.featureofinterest_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE v1.featureofinterest_id_seq OWNER TO postgres;

--
-- Name: featureofinterest_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: postgres
--

ALTER SEQUENCE v1.featureofinterest_id_seq OWNED BY v1.featureofinterest.id;


--
-- Name: historicallocation; Type: TABLE; Schema: v1; Owner: postgres
--

CREATE TABLE v1.historicallocation (
    id bigint NOT NULL,
    thing_id bigint,
    "time" timestamp with time zone
);


ALTER TABLE v1.historicallocation OWNER TO postgres;

--
-- Name: historicallocation_id_seq; Type: SEQUENCE; Schema: v1; Owner: postgres
--

CREATE SEQUENCE v1.historicallocation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE v1.historicallocation_id_seq OWNER TO postgres;

--
-- Name: historicallocation_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: postgres
--

ALTER SEQUENCE v1.historicallocation_id_seq OWNED BY v1.historicallocation.id;


--
-- Name: location; Type: TABLE; Schema: v1; Owner: postgres
--

CREATE TABLE v1.location (
    id bigint NOT NULL,
    name character varying(255),
    description character varying(500),
    encodingtype integer,
    geojson jsonb,
    location public.geometry(Geometry,4326)
);


ALTER TABLE v1.location OWNER TO postgres;

--
-- Name: location_id_seq; Type: SEQUENCE; Schema: v1; Owner: postgres
--

CREATE SEQUENCE v1.location_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE v1.location_id_seq OWNER TO postgres;

--
-- Name: location_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: postgres
--

ALTER SEQUENCE v1.location_id_seq OWNED BY v1.location.id;


--
-- Name: location_to_historicallocation; Type: TABLE; Schema: v1; Owner: postgres
--

CREATE TABLE v1.location_to_historicallocation (
    location_id bigint,
    historicallocation_id bigint
);


ALTER TABLE v1.location_to_historicallocation OWNER TO postgres;

--
-- Name: observation; Type: TABLE; Schema: v1; Owner: postgres
--

CREATE TABLE v1.observation (
    id bigint NOT NULL,
    data jsonb,
    stream_id bigint,
    featureofinterest_id bigint
);


ALTER TABLE v1.observation OWNER TO postgres;

--
-- Name: observation_id_seq; Type: SEQUENCE; Schema: v1; Owner: postgres
--

CREATE SEQUENCE v1.observation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE v1.observation_id_seq OWNER TO postgres;

--
-- Name: observation_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: postgres
--

ALTER SEQUENCE v1.observation_id_seq OWNED BY v1.observation.id;


--
-- Name: observedproperty; Type: TABLE; Schema: v1; Owner: postgres
--

CREATE TABLE v1.observedproperty (
    id bigint NOT NULL,
    name character varying(120),
    definition character varying(255),
    description character varying(500)
);


ALTER TABLE v1.observedproperty OWNER TO postgres;

--
-- Name: observedproperty_id_seq; Type: SEQUENCE; Schema: v1; Owner: postgres
--

CREATE SEQUENCE v1.observedproperty_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE v1.observedproperty_id_seq OWNER TO postgres;

--
-- Name: observedproperty_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: postgres
--

ALTER SEQUENCE v1.observedproperty_id_seq OWNED BY v1.observedproperty.id;


--
-- Name: sensor; Type: TABLE; Schema: v1; Owner: postgres
--

CREATE TABLE v1.sensor (
    id bigint NOT NULL,
    name character varying(255),
    description character varying(500),
    encodingtype integer,
    metadata text
);


ALTER TABLE v1.sensor OWNER TO postgres;

--
-- Name: sensor_id_seq; Type: SEQUENCE; Schema: v1; Owner: postgres
--

CREATE SEQUENCE v1.sensor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE v1.sensor_id_seq OWNER TO postgres;

--
-- Name: sensor_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: postgres
--

ALTER SEQUENCE v1.sensor_id_seq OWNED BY v1.sensor.id;


--
-- Name: thing; Type: TABLE; Schema: v1; Owner: postgres
--

CREATE TABLE v1.thing (
    id bigint NOT NULL,
    name character varying(255),
    description character varying(500),
    properties jsonb
);


ALTER TABLE v1.thing OWNER TO postgres;

--
-- Name: thing_id_seq; Type: SEQUENCE; Schema: v1; Owner: postgres
--

CREATE SEQUENCE v1.thing_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE v1.thing_id_seq OWNER TO postgres;

--
-- Name: thing_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: postgres
--

ALTER SEQUENCE v1.thing_id_seq OWNED BY v1.thing.id;


--
-- Name: thing_to_location; Type: TABLE; Schema: v1; Owner: postgres
--

CREATE TABLE v1.thing_to_location (
    thing_id bigint,
    location_id bigint
);


ALTER TABLE v1.thing_to_location OWNER TO postgres;

--
-- Name: datastream id; Type: DEFAULT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY v1.datastream ALTER COLUMN id SET DEFAULT nextval('v1.datastream_id_seq'::regclass);


--
-- Name: featureofinterest id; Type: DEFAULT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY v1.featureofinterest ALTER COLUMN id SET DEFAULT nextval('v1.featureofinterest_id_seq'::regclass);


--
-- Name: historicallocation id; Type: DEFAULT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY v1.historicallocation ALTER COLUMN id SET DEFAULT nextval('v1.historicallocation_id_seq'::regclass);


--
-- Name: location id; Type: DEFAULT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY v1.location ALTER COLUMN id SET DEFAULT nextval('v1.location_id_seq'::regclass);


--
-- Name: observation id; Type: DEFAULT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY v1.observation ALTER COLUMN id SET DEFAULT nextval('v1.observation_id_seq'::regclass);


--
-- Name: observedproperty id; Type: DEFAULT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY v1.observedproperty ALTER COLUMN id SET DEFAULT nextval('v1.observedproperty_id_seq'::regclass);


--
-- Name: sensor id; Type: DEFAULT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY v1.sensor ALTER COLUMN id SET DEFAULT nextval('v1.sensor_id_seq'::regclass);


--
-- Name: thing id; Type: DEFAULT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY v1.thing ALTER COLUMN id SET DEFAULT nextval('v1.thing_id_seq'::regclass);


--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- Data for Name: geocode_settings; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY tiger.geocode_settings (name, setting, unit, category, short_desc) FROM stdin;
\.


--
-- Data for Name: pagc_gaz; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY tiger.pagc_gaz (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: pagc_lex; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY tiger.pagc_lex (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: pagc_rules; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY tiger.pagc_rules (id, rule, is_custom) FROM stdin;
\.


--
-- Data for Name: topology; Type: TABLE DATA; Schema: topology; Owner: postgres
--

COPY topology.topology (id, name, srid, "precision", hasz) FROM stdin;
\.


--
-- Data for Name: layer; Type: TABLE DATA; Schema: topology; Owner: postgres
--

COPY topology.layer (topology_id, layer_id, schema_name, table_name, feature_column, feature_type, level, child_id) FROM stdin;
\.


--
-- Data for Name: datastream; Type: TABLE DATA; Schema: v1; Owner: postgres
--

COPY v1.datastream (id, name, description, unitofmeasurement, observationtype, observedarea, phenomenontime, resulttime, thing_id, sensor_id, observedproperty_id) FROM stdin;
13	Processing information	Datastream for the internal processings	{"name": "processing information", "symbol": "srfg.prusa3d.processing", "definition": "json-message"}	4	\N	\N	\N	9	6	13
14	mqtt connection status	Datastream for the mqtt network connection	{"name": "mqtt connection status", "symbol": "srfg.prusa3d.mqtt", "definition": "connection-status"}	4	\N	\N	\N	9	6	14
15	prusa events	Datastream for printing events	{"name": "printing event", "symbol": "srfg.prusa3d.event", "definition": "json-message"}	4	\N	\N	\N	9	6	15
16	IoT Labor Temperature	Temperature of the IoT Labor of Salzburg Research	{"name": "Degree Celsius", "symbol": "degC", "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#DegreeCelsius"}	3	\N	\N	\N	12	8	16
17	IoT Labor Humidity	Relative Humidity of the IoT Labor of Salzburg Research	{"name": "Percent", "symbol": "%", "definition": ""}	3	\N	\N	\N	12	8	17
9	Target Bed Temperature Prusa	Datastream for the target temperature of the Prusa 3D printer bed	{"name": "Degree Celsius", "symbol": "degC", "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#DegreeCelsius"}	3	\N	\N	\N	9	5	9
10	Actual Bed Temperature Prusa	Datastream for the measured temperature of the Prusa 3D printer bed	{"name": "Degree Celsius", "symbol": "degC", "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#DegreeCelsius"}	3	\N	\N	\N	9	5	10
1	Machine Temperature	Machine Temperature measured on the outer case	{"name": "Degree Celsius", "symbol": "degC", "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#DegreeCelsius"}	3	\N	\N	\N	2	1	1
18	Current of the Panda Robot	Used current of the Panda Roboting System in the IoT Labor of Salzburg Research	{"name": "Ampere", "symbol": "A", "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#Ampere"}	3	\N	\N	\N	10	7	18
19	Current of the Prusa 3D printer	Used current of the Prusa 3D printing System in the IoT Labor of Salzburg Research	{"name": "Ampere", "symbol": "A", "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#Ampere"}	3	\N	\N	\N	9	7	19
20	Current of the PiXtend	Used current of the PiXtend System in the IoT Labor of Salzburg Research	{"name": "Ampere", "symbol": "A", "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#Ampere"}	3	\N	\N	\N	11	7	20
21	Current of the Sigmatek PLC	Used current of the Sigmatek PLC in the IoT Labor of Salzburg Research	{"name": "Ampere", "symbol": "A", "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#Ampere"}	3	\N	\N	\N	12	7	21
2	Fan Status	This datastream describes the binary status of the fan: 0-off, 1-on	{"name": "", "symbol": "", "definition": "boolean"}	5	\N	\N	\N	2	2	2
11	Target Nozzle Temperature Prusa	Datastream for the target temperature of the Prusa 3D printer nozzle	{"name": "Degree Celsius", "symbol": "degC", "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#DegreeCelsius"}	3	\N	\N	\N	9	5	11
12	Actual Nozzle Temperature Prusa	Datastream for the measured temperature of the Prusa 3D printer nozzle	{"name": "Degree Celsius", "symbol": "degC", "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#DegreeCelsius"}	3	\N	\N	\N	9	5	12
\.


--
-- Data for Name: featureofinterest; Type: TABLE DATA; Schema: v1; Owner: postgres
--

COPY v1.featureofinterest (id, name, description, encodingtype, geojson, feature, original_location_id) FROM stdin;
\.


--
-- Data for Name: historicallocation; Type: TABLE DATA; Schema: v1; Owner: postgres
--

COPY v1.historicallocation (id, thing_id, "time") FROM stdin;
\.


--
-- Data for Name: location; Type: TABLE DATA; Schema: v1; Owner: postgres
--

COPY v1.location (id, name, description, encodingtype, geojson, location) FROM stdin;
\.


--
-- Data for Name: location_to_historicallocation; Type: TABLE DATA; Schema: v1; Owner: postgres
--

COPY v1.location_to_historicallocation (location_id, historicallocation_id) FROM stdin;
\.


--
-- Data for Name: observation; Type: TABLE DATA; Schema: v1; Owner: postgres
--

COPY v1.observation (id, data, stream_id, featureofinterest_id) FROM stdin;
\.


--
-- Data for Name: observedproperty; Type: TABLE DATA; Schema: v1; Owner: postgres
--

COPY v1.observedproperty (id, name, definition, description) FROM stdin;
3	IoT Labor Temperature	http://www.qudt.org/qudt/owl/1.0.0/quantity/Instances.html#AreaTemperature	Temperature of the IoT Labor, measured under the desk
4	Current of the Panda Robot	http://www.qudt.org/qudt/owl/1.0.0/quantity/index.html#ElectricCurrent	Current of the Panda Roboting System including the ROS PC and UPS, measured in the electrical distributor.
5	Current of the Prusa 3D printer	http://www.qudt.org/qudt/owl/1.0.0/quantity/index.html#ElectricCurrent	Current of the Prusa 3D printing System including the printer and the octoprint server, measured in the electrical distributor.
6	Current of the PiXtend	http://www.qudt.org/qudt/owl/1.0.0/quantity/index.html#ElectricCurrent	Current of the PiXtend System including the conveyor belt, measured in the electrical distributor.
7	Current of the Sigmatek PLC	http://www.qudt.org/qudt/owl/1.0.0/quantity/index.html#ElectricCurrent	Current of the Sigmatek PLC including some Raspberry Pis, measured in the electrical distributor.
8	IoT Labor Humidity	https://www.sciencedirect.com/topics/earth-and-planetary-sciences/relative-humidity	Relative Humidity of the IoT Labor, measured under the desk
9	Target Bed Temperature of the Prusa i3	http://www.qudt.org/qudt/owl/1.0.0/quantity/Instances.html#AreaTemperature	The desired temperature of the Prusa i3 printing bed
10	Actual Bed Temperature of the Prusa i3	http://www.qudt.org/qudt/owl/1.0.0/quantity/Instances.html#AreaTemperature	The measured temperature of the Prusa i3 printing bed
1	Machine Temperature	http://www.qudt.org/qudt/owl/1.0.0/quantity/Instances.html#AreaTemperature	Temperature of the machine's case on the outer side
2	Fan Status	http://www.opengis.net/def/observationType/OGC-OM/2.0/OM_TruthObservation	This datastream describes the binary status of the fan: 0-off, 1-on
11	Target Nozzle Temperature of the Prusa i3	http://www.qudt.org/qudt/owl/1.0.0/quantity/Instances.html#AreaTemperature	The desired temperature of the Prusa i3 nozzle
12	Actual Nozzle Temperature of the Prusa i3	http://www.qudt.org/qudt/owl/1.0.0/quantity/Instances.html#AreaTemperature	The measured temperature of the Prusa i3 nozzle
13	processing data	srfg.prusa3d.processing	processes run to perform a print (printing, slicing)
14	network information	srfg.prusa3d.mqtt	mqtt network connection of the printer's controller
15	event information	srfg.prusa3d.event	events occurring while printing
16	IoT Labor Temperature	http://www.qudt.org/qudt/owl/1.0.0/quantity/Instances.html#AreaTemperature	Temperature of the IoT Labor, measured under the desk
17	IoT Labor Humidity	https://www.sciencedirect.com/topics/earth-and-planetary-sciences/relative-humidity	Relative Humidity of the IoT Labor, measured under the desk
18	Current of the Panda Robot	http://www.qudt.org/qudt/owl/1.0.0/quantity/index.html#ElectricCurrent	Current of the Panda Roboting System including the ROS PC and UPS, measured in the electrical distributor.
19	Current of the Prusa 3D printer	http://www.qudt.org/qudt/owl/1.0.0/quantity/index.html#ElectricCurrent	Current of the Prusa 3D printing System including the printer and the octoprint server, measured in the electrical distributor.
20	Current of the PiXtend	http://www.qudt.org/qudt/owl/1.0.0/quantity/index.html#ElectricCurrent	Current of the PiXtend System including the conveyor belt, measured in the electrical distributor.
21	Current of the Sigmatek PLC	http://www.qudt.org/qudt/owl/1.0.0/quantity/index.html#ElectricCurrent	Current of the Sigmatek PLC including some Raspberry Pis, measured in the electrical distributor.
\.


--
-- Data for Name: sensor; Type: TABLE DATA; Schema: v1; Owner: postgres
--

COPY v1.sensor (id, name, description, encodingtype, metadata) FROM stdin;
2	CFM-7010	CFM-7010-13 cooling fan	2	https://www.cui.com/product/resource/cfm-70-series.pdf
4	Split Core Current Transformer	Split Core Current Transformer SCT-013 with up to 5A/1V, 3.5 mm cable	2	https://datasheetspdf.com/pdf-down/S/C/T/SCT-013-005-ETC.pdf
1	DHT11	DHT11 temperature and humidity sensor	2	https://cdn-learn.adafruit.com/downloads/pdf/dht.pdf
5	prusa internal temp sensor	Internal temperature sensor of the Prusa i3 3D Printer	2	https://www.prusa3d.com/downloads/manual/prusa3d_manual_175_en.pdf
6	prusa internal controller	Derived Output from the internal controller of the Prusa i3 3D Printer	2	https://www.prusa3d.com/downloads/manual/prusa3d_manual_175_en.pdf
7	Split Core Current Transformer	Split Core Current Transformer SCT-013 with up to 5A/1V, 3.5 mm cable	2	https://datasheetspdf.com/pdf-down/S/C/T/SCT-013-005-ETC.pdf
8	DHT11	DHT11 temperature and humidity sensor	2	https://cdn-learn.adafruit.com/downloads/pdf/dht.pdf
\.


--
-- Data for Name: thing; Type: TABLE DATA; Schema: v1; Owner: postgres
--

COPY v1.thing (id, name, description, properties) FROM stdin;
10	Panda	Franka Emika Panda robot in the Iot Lab Salzburg on the central desk	{"specification": "https://s3-eu-central-1.amazonaws.com/franka-de-uploads-staging/uploads/2018/05/2018-05-datasheet-panda.pdf"}
11	PiXtend	PiXtend PLC including the conveyor belt in the Iot Lab Salzburg on the central desk	{"specification": "https://ecksteinimg.de/Datasheet/Dobot/Conveyor-Belt-Instruction.pdf"}
1	Prusa i3	3D Printer Prusa i3 MK3 in the Iot Lab Salzburg on the central desk	{"kafka": {"hosts": ["il081:9093", "il082:9094", "il083:9095"], "topics": {"logs": "dtz-logging", "metrics": "dtz-sensorthings"}}, "specification": "https://www.prusa3d.com/downloads/manual/prusa3d_manual_175_en.pdf"}
6	Panda	Franka Emika Panda robot in the Iot Lab Salzburg on the central desk	{"specification": "https://s3-eu-central-1.amazonaws.com/franka-de-uploads-staging/uploads/2018/05/2018-05-datasheet-panda.pdf"}
7	PiXtend	PiXtend PLC including the conveyor belt in the Iot Lab Salzburg on the central desk	{"specification": "https://ecksteinimg.de/Datasheet/Dobot/Conveyor-Belt-Instruction.pdf"}
8	Sigmatek	Sigmatek PLC as well as miscellaneous non-acting systems	{}
2	Demo Machine	Machine to demonstrate the functionalities of the Digital Twin Stack	{"specification": "https://www.machine-url.com/downloads/demo-machine.pdf"}
9	Prusa i3	3D Printer Prusa i3 MK3 in the Iot Lab Salzburg on the central desk	{"kafka": {"hosts": ["il081:9093", "il082:9094", "il083:9095"], "topics": {"logs": "dtz-logging", "metrics": "dtz-sensorthings"}}, "specification": "https://www.prusa3d.com/downloads/manual/prusa3d_manual_175_en.pdf"}
12	Sigmatek	Sigmatek PLC as well as miscellaneous non-acting systems	{}
\.


--
-- Data for Name: thing_to_location; Type: TABLE DATA; Schema: v1; Owner: postgres
--

COPY v1.thing_to_location (thing_id, location_id) FROM stdin;
\.


--
-- Name: datastream_id_seq; Type: SEQUENCE SET; Schema: v1; Owner: postgres
--

SELECT pg_catalog.setval('v1.datastream_id_seq', 21, true);


--
-- Name: featureofinterest_id_seq; Type: SEQUENCE SET; Schema: v1; Owner: postgres
--

SELECT pg_catalog.setval('v1.featureofinterest_id_seq', 1, false);


--
-- Name: historicallocation_id_seq; Type: SEQUENCE SET; Schema: v1; Owner: postgres
--

SELECT pg_catalog.setval('v1.historicallocation_id_seq', 1, false);


--
-- Name: location_id_seq; Type: SEQUENCE SET; Schema: v1; Owner: postgres
--

SELECT pg_catalog.setval('v1.location_id_seq', 1, false);


--
-- Name: observation_id_seq; Type: SEQUENCE SET; Schema: v1; Owner: postgres
--

SELECT pg_catalog.setval('v1.observation_id_seq', 1, false);


--
-- Name: observedproperty_id_seq; Type: SEQUENCE SET; Schema: v1; Owner: postgres
--

SELECT pg_catalog.setval('v1.observedproperty_id_seq', 21, true);


--
-- Name: sensor_id_seq; Type: SEQUENCE SET; Schema: v1; Owner: postgres
--

SELECT pg_catalog.setval('v1.sensor_id_seq', 10, true);


--
-- Name: thing_id_seq; Type: SEQUENCE SET; Schema: v1; Owner: postgres
--

SELECT pg_catalog.setval('v1.thing_id_seq', 12, true);


--
-- Name: datastream datastream_pkey; Type: CONSTRAINT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY v1.datastream
    ADD CONSTRAINT datastream_pkey PRIMARY KEY (id);


--
-- Name: featureofinterest featureofinterest_pkey; Type: CONSTRAINT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY v1.featureofinterest
    ADD CONSTRAINT featureofinterest_pkey PRIMARY KEY (id);


--
-- Name: historicallocation historicallocation_pkey; Type: CONSTRAINT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY v1.historicallocation
    ADD CONSTRAINT historicallocation_pkey PRIMARY KEY (id);


--
-- Name: location location_pkey; Type: CONSTRAINT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY v1.location
    ADD CONSTRAINT location_pkey PRIMARY KEY (id);


--
-- Name: observedproperty observedproperty_pkey; Type: CONSTRAINT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY v1.observedproperty
    ADD CONSTRAINT observedproperty_pkey PRIMARY KEY (id);


--
-- Name: sensor sensor_pkey; Type: CONSTRAINT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY v1.sensor
    ADD CONSTRAINT sensor_pkey PRIMARY KEY (id);


--
-- Name: thing thing_pkey; Type: CONSTRAINT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY v1.thing
    ADD CONSTRAINT thing_pkey PRIMARY KEY (id);


--
-- Name: fki_featureofinterest; Type: INDEX; Schema: v1; Owner: postgres
--

CREATE INDEX fki_featureofinterest ON v1.observation USING btree (featureofinterest_id);


--
-- Name: fki_historicallocation_1; Type: INDEX; Schema: v1; Owner: postgres
--

CREATE INDEX fki_historicallocation_1 ON v1.location_to_historicallocation USING btree (historicallocation_id);


--
-- Name: fki_location_1; Type: INDEX; Schema: v1; Owner: postgres
--

CREATE INDEX fki_location_1 ON v1.thing_to_location USING btree (location_id);


--
-- Name: fki_location_2; Type: INDEX; Schema: v1; Owner: postgres
--

CREATE INDEX fki_location_2 ON v1.location_to_historicallocation USING btree (location_id);


--
-- Name: fki_observedproperty; Type: INDEX; Schema: v1; Owner: postgres
--

CREATE INDEX fki_observedproperty ON v1.datastream USING btree (observedproperty_id);


--
-- Name: fki_sensor; Type: INDEX; Schema: v1; Owner: postgres
--

CREATE INDEX fki_sensor ON v1.datastream USING btree (sensor_id);


--
-- Name: fki_thing; Type: INDEX; Schema: v1; Owner: postgres
--

CREATE INDEX fki_thing ON v1.datastream USING btree (thing_id);


--
-- Name: fki_thing_1; Type: INDEX; Schema: v1; Owner: postgres
--

CREATE INDEX fki_thing_1 ON v1.thing_to_location USING btree (thing_id);


--
-- Name: fki_thing_hl; Type: INDEX; Schema: v1; Owner: postgres
--

CREATE INDEX fki_thing_hl ON v1.historicallocation USING btree (thing_id);


--
-- Name: i_dsid_id; Type: INDEX; Schema: v1; Owner: postgres
--

CREATE INDEX i_dsid_id ON v1.observation USING btree (stream_id, id);


--
-- Name: i_id; Type: INDEX; Schema: v1; Owner: postgres
--

CREATE INDEX i_id ON v1.observation USING btree (id);


--
-- Name: location_to_historicallocation location_deleted; Type: TRIGGER; Schema: v1; Owner: postgres
--

CREATE TRIGGER location_deleted AFTER DELETE ON v1.location_to_historicallocation FOR EACH ROW EXECUTE PROCEDURE v1.delete_coupled_historicallocation();


--
-- Name: observation fk_datastream; Type: FK CONSTRAINT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY v1.observation
    ADD CONSTRAINT fk_datastream FOREIGN KEY (stream_id) REFERENCES v1.datastream(id) ON DELETE CASCADE;


--
-- Name: observation fk_featureofinterest; Type: FK CONSTRAINT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY v1.observation
    ADD CONSTRAINT fk_featureofinterest FOREIGN KEY (featureofinterest_id) REFERENCES v1.featureofinterest(id) ON DELETE CASCADE;


--
-- Name: location_to_historicallocation fk_historicallocation_1; Type: FK CONSTRAINT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY v1.location_to_historicallocation
    ADD CONSTRAINT fk_historicallocation_1 FOREIGN KEY (historicallocation_id) REFERENCES v1.historicallocation(id) ON DELETE CASCADE;


--
-- Name: thing_to_location fk_location_1; Type: FK CONSTRAINT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY v1.thing_to_location
    ADD CONSTRAINT fk_location_1 FOREIGN KEY (location_id) REFERENCES v1.location(id) ON DELETE CASCADE;


--
-- Name: location_to_historicallocation fk_location_2; Type: FK CONSTRAINT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY v1.location_to_historicallocation
    ADD CONSTRAINT fk_location_2 FOREIGN KEY (location_id) REFERENCES v1.location(id) ON DELETE CASCADE;


--
-- Name: datastream fk_observedproperty; Type: FK CONSTRAINT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY v1.datastream
    ADD CONSTRAINT fk_observedproperty FOREIGN KEY (observedproperty_id) REFERENCES v1.observedproperty(id) ON DELETE CASCADE;


--
-- Name: datastream fk_sensor; Type: FK CONSTRAINT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY v1.datastream
    ADD CONSTRAINT fk_sensor FOREIGN KEY (sensor_id) REFERENCES v1.sensor(id) ON DELETE CASCADE;


--
-- Name: datastream fk_thing; Type: FK CONSTRAINT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY v1.datastream
    ADD CONSTRAINT fk_thing FOREIGN KEY (thing_id) REFERENCES v1.thing(id) ON DELETE CASCADE;


--
-- Name: thing_to_location fk_thing_1; Type: FK CONSTRAINT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY v1.thing_to_location
    ADD CONSTRAINT fk_thing_1 FOREIGN KEY (thing_id) REFERENCES v1.thing(id) ON DELETE CASCADE;


--
-- Name: historicallocation fk_thing_hl; Type: FK CONSTRAINT; Schema: v1; Owner: postgres
--

ALTER TABLE ONLY v1.historicallocation
    ADD CONSTRAINT fk_thing_hl FOREIGN KEY (thing_id) REFERENCES v1.thing(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

