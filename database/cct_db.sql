--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.6
-- Dumped by pg_dump version 9.6.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

DROP DATABASE IF EXISTS "cct";
CREATE DATABASE "cct" WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'american_usa' LC_CTYPE = 'american_usa';
\connect "cct"
--
-- Name: activities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE activities (
    id integer NOT NULL,
    name text,
    unit_id integer,
    contractor_id integer,
    unit_cost double precision,
    total_planned_hours integer,
    project_id integer,
    total_planned_units bigint,
    planned_start date,
    planned_end date,
    unit_name text,
    actual_start date,
    actual_end date,
    hourly_cost double precision,
    required_activities integer[],
    phase_id integer,
    total_planned_resources integer,
    external_id text,
    is_deleted integer DEFAULT 0,
	is_milestone integer DEFAULT 0,
    material_id integer,
    material_quantity integer,
    material_status text
);


--
-- Name: activities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE activities_id_seq OWNED BY activities.id;


--
-- Name: activity_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE activity_data (
    id integer NOT NULL,
    activity_id integer NOT NULL,
    "date" "date",
    actual_hours integer,
    actual_units integer,
    planned_hours bigint,
    planned_units double precision,
    updated timestamp without time zone,
    created timestamp without time zone,
    actual_resources integer,
    planned_resources integer
);


--
-- Name: activity_data_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE activity_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activity_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE activity_data_id_seq OWNED BY activity_data.id;


--
-- Name: activity_dependencies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE activity_dependencies (
    id integer NOT NULL,
    activity_id integer,
    required_activity_id integer
);


--
-- Name: activity_dependencies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE activity_dependencies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activity_dependencies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE activity_dependencies_id_seq OWNED BY activity_dependencies.id;


--
-- Name: bundle_activities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE bundle_activities (
    bundle_id integer,
    activity_id integer,
    id smallint NOT NULL
);


--
-- Name: bundle_activities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bundle_activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


--
-- Name: bundle_activities_id_seq1; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bundle_activities_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bundle_activities_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bundle_activities_id_seq1 OWNED BY bundle_activities.id;


--
-- Name: bundle_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bundle_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


--
-- Name: bundle_phases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE bundle_phases (
    id bigint NOT NULL,
    bundle_id integer,
    phase_id integer
);


--
-- Name: bundle_phases_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bundle_phases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bundle_phases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bundle_phases_id_seq OWNED BY bundle_phases.id;


--
-- Name: bundle_tasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE bundle_tasks (
    "int" smallint NOT NULL,
    bundle_id integer,
    task_id integer
);


--
-- Name: bundle_tasks_int_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bundle_tasks_int_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bundle_tasks_int_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bundle_tasks_int_seq OWNED BY bundle_tasks."int";


--
-- Name: bundles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE bundles (
    id integer DEFAULT nextval(('public.bundle_id_seq'::text)::regclass) NOT NULL,
    parent_bundle_id integer,
    name text,
    project_id integer,
    title text,
    phase_id integer
);


--
-- Name: change_orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE change_orders (
    id integer DEFAULT nextval(('public.change_orders'::text)::regclass) NOT NULL,
    project_id integer,
    contractor_id integer,
    description text,
    approved_cost double precision,
    estimted_cost double precision,
    date_submitted date,
    date_approved date,
    percent_complete double precision
);


--
-- Name: clients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE clients (
    id integer NOT NULL,
    name text,
    logo_url text,
    dashboards text[],
    default_section text
);


--
-- Name: clients_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE clients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE clients_id_seq OWNED BY clients.id;


--
-- Name: contractors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contractors (
    name text,
    email text,
    phone text,
    pm_contact character varying,
    id smallint NOT NULL
);


--
-- Name: contractors_id_seq1; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE contractors_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contractors_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE contractors_id_seq1 OWNED BY contractors.id;


--
-- Name: incident_classes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE incident_classes (
    id integer NOT NULL,
    name text
);


--
-- Name: incident_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE incident_types (
    id integer NOT NULL,
    name text
);


--
-- Name: incidents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE incidents (
    id integer NOT NULL,
    "date" "date",
    contractor_id integer,
    incident_type_id integer,
    incident_class_id integer,
    project_id integer
);


--
-- Name: incidents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE incidents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: incidents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE incidents_id_seq OWNED BY incidents.id;


--
-- Name: indirect_costs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE indirect_costs (
    id integer NOT NULL,
    actual_amount double precision,
    planned_amount integer,
    project_id integer
);


--
-- Name: installations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE installations (
    id integer DEFAULT nextval(('public.installations'::text)::regclass) NOT NULL,
    item_id integer,
    date_installed date,
    units_installed integer,
    units_failed integer,
    project_id integer
);


--
-- Name: invoices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE invoices (
    id integer NOT NULL,
    activity_id integer,
    amount double precision,
    date_invoiced date
);


--
-- Name: issue_statuses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE issue_statuses (
    id integer NOT NULL,
    name text
);


--
-- Name: issues; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE issues (
    id integer NOT NULL,
    name text,
    responsible text,
    description text,
    status text,
    resolution text,
    deadline date,
    updated_by text,
    updated date,
    activity_id integer,
    issue_status_id integer
);


--
-- Name: items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE items (
    id integer NOT NULL,
    name character varying(100)
);


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE locations (
    street text,
    city text,
    state text,
    country text,
    latitude double precision,
    longitude double precision,
    id smallint NOT NULL
);


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


--
-- Name: locations_id_seq1; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE locations_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE locations_id_seq1 OWNED BY locations.id;


--
-- Name: materials; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE materials (
    id integer NOT NULL,
    name text,
    vendor text,
    external_id text
);


--
-- Name: materials_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE materials_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: materials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE materials_id_seq OWNED BY materials.id;


--
-- Name: milestones; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE milestones (
    name text,
    actual date,
    planned date,
    contract date,
    project_id integer,
    phase_id integer,
    id smallint NOT NULL
);


--
-- Name: milestones_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE milestones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: milestones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE milestones_id_seq OWNED BY milestones.id;


--
-- Name: ncrs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ncrs (
    id integer DEFAULT nextval(('public.ncrs'::text)::regclass) NOT NULL,
    project_id integer,
    contractor_id integer,
    description text,
    date_open date,
    date_closed date
);


--
-- Name: new_table_0_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE new_table_0_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: new_table_0_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE new_table_0_id_seq OWNED BY incident_types.id;


--
-- Name: new_table_0_id_seq1; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE new_table_0_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: new_table_0_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE new_table_0_id_seq1 OWNED BY incident_classes.id;


--
-- Name: new_table_0_id_seq2; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE new_table_0_id_seq2
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: new_table_0_id_seq2; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE new_table_0_id_seq2 OWNED BY issues.id;


--
-- Name: new_table_1_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE new_table_1_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: new_table_1_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE new_table_1_id_seq OWNED BY issue_statuses.id;


--
-- Name: phases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE phases (
    name text,
    scheduled_start date,
    scheduled_end text,
    actual_start text,
    actual_end date,
    id smallint NOT NULL,
    project_id integer,
    planned_start date,
    planned_end date
);


--
-- Name: phases_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE phases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: phases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE phases_id_seq OWNED BY phases.id;


--
-- Name: portfolio_projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE portfolio_projects (
    id integer NOT NULL,
    portfolio_id integer,
    project_id integer
);


--
-- Name: portfolio_projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE portfolio_projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: portfolio_projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE portfolio_projects_id_seq OWNED BY portfolio_projects.id;


--
-- Name: portfolios; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE portfolios (
    id integer NOT NULL,
    name text
);


--
-- Name: portfolios_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE portfolios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: portfolios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE portfolios_id_seq OWNED BY portfolios.id;


--
-- Name: procurements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE procurements (
    id integer DEFAULT nextval(('public.procurements'::text)::regclass) NOT NULL,
    name text,
    date_needed date,
    date_delivered date,
    project_id integer,
    item_id integer
);


--
-- Name: projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE projects (
    id integer DEFAULT nextval(('public.projects_id_seq'::text)::regclass) NOT NULL,
    name text,
    start date,
    "end" date,
    workdays json,
    budget integer,
    bundle_title text,
    location_id integer,
    contingency bigint
);


--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


--
-- Name: task_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE task_history (
    id smallint NOT NULL,
    task_id integer,
    description text,
    created date,
    updated date,
    hours numeric(255,0)
);


--
-- Name: task_history_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE task_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: task_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE task_history_id_seq OWNED BY task_history.id;


--
-- Name: tasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tasks (
    id smallint NOT NULL,
    name character varying(255),
    actual_start date,
    actual_end date,
    planned_start date,
    planed_end date,
    contractor_id integer,
    percent_complete character varying(255),
    updated date,
    created date
);


--
-- Name: tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tasks_id_seq OWNED BY tasks.id;


--
-- Name: units; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE units (
    id integer DEFAULT nextval(('public.units'::text)::regclass) NOT NULL,
    name text
);


--
-- Name: variance_reasons; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE variance_reasons (
    id integer DEFAULT nextval(('public.variance_reasons'::text)::regclass) NOT NULL,
    name text
);


--
-- Name: variances; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE variances (
    id integer DEFAULT nextval(('public.variances'::text)::regclass) NOT NULL,
    activity_id integer,
    reported_date date,
    updated_date date,
    reason_id integer,
    comment text
);


--
-- Name: weightings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE weightings (
    id integer DEFAULT nextval(('public.weightings'::text)::regclass) NOT NULL,
    score text,
    weighting numeric
);


--
-- Name: activities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY activities ALTER COLUMN id SET DEFAULT nextval('activities_id_seq'::regclass);


--
-- Name: activity_data id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY activity_data ALTER COLUMN id SET DEFAULT nextval('activity_data_id_seq'::regclass);


--
-- Name: activity_dependencies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY activity_dependencies ALTER COLUMN id SET DEFAULT nextval('activity_dependencies_id_seq'::regclass);


--
-- Name: bundle_activities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bundle_activities ALTER COLUMN id SET DEFAULT nextval('bundle_activities_id_seq1'::regclass);


--
-- Name: bundle_phases id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bundle_phases ALTER COLUMN id SET DEFAULT nextval('bundle_phases_id_seq'::regclass);


--
-- Name: bundle_tasks int; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bundle_tasks ALTER COLUMN "int" SET DEFAULT nextval('bundle_tasks_int_seq'::regclass);


--
-- Name: clients id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY clients ALTER COLUMN id SET DEFAULT nextval('clients_id_seq'::regclass);


--
-- Name: contractors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY contractors ALTER COLUMN id SET DEFAULT nextval('contractors_id_seq1'::regclass);


--
-- Name: incident_classes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY incident_classes ALTER COLUMN id SET DEFAULT nextval('new_table_0_id_seq1'::regclass);


--
-- Name: incident_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY incident_types ALTER COLUMN id SET DEFAULT nextval('new_table_0_id_seq'::regclass);


--
-- Name: incidents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY incidents ALTER COLUMN id SET DEFAULT nextval('incidents_id_seq'::regclass);


--
-- Name: issue_statuses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY issue_statuses ALTER COLUMN id SET DEFAULT nextval('new_table_1_id_seq'::regclass);


--
-- Name: issues id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY issues ALTER COLUMN id SET DEFAULT nextval('new_table_0_id_seq2'::regclass);


--
-- Name: locations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY locations ALTER COLUMN id SET DEFAULT nextval('locations_id_seq1'::regclass);


--
-- Name: materials id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY materials ALTER COLUMN id SET DEFAULT nextval('materials_id_seq'::regclass);


--
-- Name: milestones id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY milestones ALTER COLUMN id SET DEFAULT nextval('milestones_id_seq'::regclass);


--
-- Name: phases id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY phases ALTER COLUMN id SET DEFAULT nextval('phases_id_seq'::regclass);


--
-- Name: portfolio_projects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY portfolio_projects ALTER COLUMN id SET DEFAULT nextval('portfolio_projects_id_seq'::regclass);


--
-- Name: portfolios id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY portfolios ALTER COLUMN id SET DEFAULT nextval('portfolios_id_seq'::regclass);


--
-- Name: task_history id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY task_history ALTER COLUMN id SET DEFAULT nextval('task_history_id_seq'::regclass);


--
-- Name: tasks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tasks ALTER COLUMN id SET DEFAULT nextval('tasks_id_seq'::regclass);


--
-- Data for Name: activities; Type: TABLE DATA; Schema: public; Owner: -
--

COPY activities (id, name, unit_id, contractor_id, unit_cost, total_planned_hours, project_id, total_planned_units, planned_start, planned_end, unit_name, actual_start, actual_end, hourly_cost, required_activities, phase_id, total_planned_resources, external_id, is_deleted, material_id, material_quantity, material_status) FROM stdin;
475	Stud bolts	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	\N	\N	\N	\N	3	\N	\N	0	153	1	Ordered
554	Stud bolt placement	\N	\N	\N	100	1	100	2018-07-01	2018-09-01	Stud bolts	\N	\N	\N	\N	4	12	\N	0	\N	\N	\N
478	Expansion bellows	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	\N	\N	\N	\N	3	\N	\N	0	156	1	Ordered
481	Primary supports	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	\N	\N	\N	\N	3	\N	\N	0	159	1	Ordered
469	additional scope (MOM-078) equipments	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	2018-07-01	\N	\N	3	\N	\N	0	147	1	Ordered
470	Insulation	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	2018-07-01	\N	\N	3	\N	\N	0	148	1	Ordered
471	Pipes	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	2018-07-01	\N	\N	3	\N	\N	0	149	1	Ordered
472	Valves	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	150	1	Ordered
473	Flanges	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	151	1	Ordered
474	Fittings	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	152	1	Ordered
476	Steam traps	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	154	1	Ordered
477	Gaskets	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	155	1	Ordered
479	Strainers	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	157	1	Ordered
480	Sight glass	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	158	1	Ordered
482	Special supports	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	160	1	Ordered
483	Compact substation	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	161	1	Ordered
484	Construction power	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	162	1	Ordered
485	Transformers	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	163	1	Ordered
486	HT panel	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	164	1	Ordered
488	NGR	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	166	1	Ordered
529	Governor	\N	\N	\N	\N	1	\N	2018-07-01	2018-08-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	207	1	Ordered
492	VFD	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	2018-06-20	\N	\N	3	\N	\N	0	170	1	Ordered
507	PA system	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	2018-07-20	\N	\N	3	\N	\N	0	185	1	Ordered
513	Light fittings	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	2018-07-25	\N	\N	3	\N	\N	0	191	1	Ordered
555	Paving	\N	\N	\N	3200	1	1000	2018-07-01	2018-08-01	Meters	2018-07-01	\N	\N	\N	4	12	\N	0	\N	\N	\N
489	HT cables	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	167	1	Ordered
490	DG	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	168	1	Ordered
491	UPS	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	169	1	Ordered
493	LT PCC	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	171	1	Ordered
494	MCC	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	172	1	Ordered
495	Battery and battery charger	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	173	1	Ordered
414	PFAlined pumps	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	92	1	Ordered
415	Metering pumps	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	93	1	Ordered
416	ETP package	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	94	1	Ordered
417	Ammonia compressor	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	95	1	Ordered
418	Chlorination package	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	96	1	Ordered
419	Filters	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	97	1	Ordered
420	Mist separator	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	98	1	Ordered
421	Surface condenser pump	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	99	1	Ordered
422	Rotary vane pumps	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	100	1	Ordered
435	Mixer	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	113	1	Ordered
496	Buss duct	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	174	1	Ordered
497	HT motors	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	175	1	Ordered
498	APFC panel	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	176	1	Ordered
499	LT motors	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	177	1	Ordered
500	Local control stations	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	178	1	Ordered
501	Control cables (Deleted)	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	179	1	Ordered
502	Jointing kits (Deleted)	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	180	1	Ordered
503	Lighting transformers (Deleted)	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	181	1	Ordered
504	Cable tray	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	182	1	Ordered
505	Earthing strips (Deleted)	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	183	1	Ordered
506	Lightening arrestors (Deleted)	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	184	1	Ordered
508	Switchyard (Deleted)	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	186	1	Ordered
509	LT cables	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	187	1	Ordered
510	HT Capacitor bank	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	188	1	Ordered
511	EPBAX system	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	189	1	Ordered
512	Electrical installation	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	190	1	Ordered
514	CCTV	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	192	1	Ordered
515	UMPS	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	193	1	Ordered
516	Misc. panels	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	194	1	Ordered
517	Electrical heat tracing	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	195	1	Ordered
518	Weigh bridge	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	196	1	Ordered
519	Ordering ofVibration montoring system	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	197	1	Ordered
520	DCS system	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	198	1	Ordered
521	Control valves- CNA Plants	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	199	1	Ordered
522	On/Off valves- WNA Plant	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	200	1	Ordered
523	On/Off valves- CNA Plants	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	201	1	Ordered
524	On/Off valves- Offsites & Utilities	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	202	1	Ordered
525	Flow meters- Offsites & Utilities	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	203	1	Ordered
526	Control valves- Offsites & Utilities	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	204	1	Ordered
527	Control valves- WNA Plant	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	205	1	Ordered
528	Anti surge controller	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	206	1	Ordered
530	Flow meters- WNA Plant	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	208	1	Ordered
531	Flow meters- CNA Plants	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	209	1	Ordered
532	Analysers/Gas detectors- CNA Plants	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	210	1	Ordered
533	Analysers/Gas detectors- Offsites & Utilities	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	211	1	Ordered
534	Analysers/Gas detectors- WNA Plant (Deleted)	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	212	1	Ordered
535	Switches- WNA Plant (Deleted)	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	213	1	Ordered
540	DIN Rail Transmitters- CNA Plant (Deleted)	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	218	1	Ordered
541	Transmitters- WNA Plant	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	219	1	Ordered
542	Saftey items- WNA Plant	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	220	1	Ordered
543	Gauges- WNA Plant	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	221	1	Ordered
544	Fire alarm system	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	222	1	Ordered
545	Transmitters- CNA Plants	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	223	1	Ordered
546	Transmitters- Offsites & Utilities	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	224	1	Ordered
547	Saftey items- CNA Plants	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	225	1	Ordered
549	Gauges- CNA Plants	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	227	1	Ordered
550	Gauges- Offsites & Utilities	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	228	1	Ordered
537	Cable trays	\N	\N	\N	\N	1	\N	2018-07-01	2018-08-01	\N	2018-07-05	\N	\N	\N	3	\N	\N	0	215	1	Ordered
538	Instrument cables	\N	\N	\N	\N	1	\N	2018-07-01	2018-08-01	\N	2018-07-01	\N	\N	\N	3	\N	\N	0	216	1	Ordered
539	Switches- CNA Plants (Deleted)	\N	\N	\N	\N	1	\N	2018-07-01	2018-08-01	\N	2018-07-10	\N	\N	\N	3	\N	\N	0	217	1	Ordered
536	bulk materials (Deleted)	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	2018-07-25	\N	\N	3	\N	\N	0	214	1	Ordered
548	Saftey items- Offsites & Utilities	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	2018-07-26	\N	\N	3	\N	\N	0	226	1	Ordered
454	Architectural work (Covered in Part I & II)	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	2018-07-27	\N	\N	3	\N	\N	0	132	1	Ordered
551	Junction boxes	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	229	1	Ordered
552	Instrument installation	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	230	1	Ordered
553	Switches- Offsites & Utilities	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	231	1	Ordered
451	Boundary wall	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	129	1	Ordered
452	Pre-fabricated structure	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	130	1	Ordered
453	Piling work	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	131	1	Ordered
455	Industrial painting (Covered in Part I & II)	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	133	1	Ordered
456	Roads & drain work (Covered in Part I & II)	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	134	1	Ordered
412	De-alkalizer (Deleted)	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	2018-07-23	\N	\N	3	\N	\N	0	90	1	Ordered
457	Civil & structural work (Part-I)	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	135	1	Ordered
487	HT PCC	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	165	1	Ordered
408	Non-API pumps	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	86	1	Ordered
409	Ejectors	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	87	1	Ordered
410	Cooling water pumps	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	88	1	Ordered
411	Side stream filter package	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	89	1	Ordered
413	STG for CPP package	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	91	1	Ordered
395	Chiller unit	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	73	1	Ordered
396	Agitators	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	74	1	Ordered
397	Raw water treatment plant	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	75	1	Ordered
398	Cooling tower package	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	76	1	Ordered
399	Fire fighting package	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	77	1	Ordered
400	DM plant	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	78	1	Ordered
401	API pumps- CNA Plants	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	79	1	Ordered
402	Air compressor	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	80	1	Ordered
403	Air drier	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	81	1	Ordered
404	Deareator	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	82	1	Ordered
405	Boiler for CPP package	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	83	1	Ordered
406	Inlet air filter	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	84	1	Ordered
407	Non-API pumps- WNA Plant	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	85	1	Ordered
450	Soil testing	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	128	1	Ordered
423	Platinum filter (Internals)	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	101	1	Ordered
424	Ammonia transfer pumps	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	102	1	Ordered
425	Extended shaft pumps	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	103	1	Ordered
426	Desuperheater	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	104	1	Ordered
427	Vacuum jet	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	105	1	Ordered
428	Lube oil pumps	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	106	1	Ordered
429	Non-metallic tanks	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	107	1	Ordered
430	Safety shower/Eye wash	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	108	1	Ordered
431	Packings/Internals	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	109	1	Ordered
432	Lift (CNA)	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	110	1	Ordered
433	Condensate transfer pumps	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	111	1	Ordered
434	HVAC package	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	112	1	Ordered
436	Ammonia scrubber	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	114	1	Ordered
437	Lube oil filters	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	115	1	Ordered
438	Plate type exchangers (Deleted)	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	116	1	Ordered
439	Loading arms	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	117	1	Ordered
440	Flame arrestors (Deleted)	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	118	1	Ordered
441	Breather valves (Deleted)	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	119	1	Ordered
442	NG station (Deleted)	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	120	1	Ordered
443	EOT Cranes	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	121	1	Ordered
444	API pumps- Offsites & Utilites (Deleted)	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	122	1	Ordered
445	Roof vent fan (Deleted)	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	123	1	Ordered
446	Inlet air silencer (Deleted)	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	124	1	Ordered
447	Chemical skids	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	125	1	Ordered
448	Silica gel	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	126	1	Ordered
449	Ammonia effluent transfer pumps (Mobile)	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	127	1	Ordered
465	CNA Plant equipments	\N	\N	\N	\N	1	100	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	143	1	Ordered
458	Civil & structural work (Part-II)	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	136	1	Ordered
459	Acid resistant tiling (Covered in Part-II)	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	137	1	Ordered
460	Boiler precast chimney	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	138	1	Ordered
461	Structural steel (Deleted)	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	139	1	Ordered
462	Reinforcement steel (Deleted)	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	140	1	Ordered
463	Cement (Deleted)	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	141	1	Ordered
464	WNA Plant equipments	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	142	1	Ordered
466	OSBL equipments	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	144	1	Ordered
467	Absorber foundation bolt & template	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	145	1	Ordered
468	Mechanical erection & piping	\N	\N	\N	\N	1	\N	2018-06-01	2018-07-01	\N	2018-06-01	\N	\N	\N	3	\N	\N	0	146	1	Ordered
\.


--
-- Name: activities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('activities_id_seq', 555, true);


--
-- Data for Name: activity_data; Type: TABLE DATA; Schema: public; Owner: -
--

COPY activity_data (id, activity_id, date, actual_hours, actual_units, planned_hours, planned_units, updated, created, actual_resources, planned_resources) FROM stdin;
4821	555	2018-07-01	\N	\N	0	0	\N	\N	\N	0
4931	554	2018-08-12	\N	\N	0	0	\N	\N	\N	0
4932	554	2018-08-13	\N	\N	2	2	\N	\N	\N	12
4933	554	2018-08-14	\N	\N	2	2	\N	\N	\N	12
4934	554	2018-08-15	\N	\N	2	2	\N	\N	\N	12
4935	554	2018-08-16	\N	\N	2	2	\N	\N	\N	12
4936	554	2018-08-17	\N	\N	2	2	\N	\N	\N	12
4828	555	2018-07-08	\N	\N	0	0	\N	\N	\N	0
4937	554	2018-08-18	\N	\N	2	2	\N	\N	\N	12
4938	554	2018-08-19	\N	\N	0	0	\N	\N	\N	0
4939	554	2018-08-20	\N	\N	2	2	\N	\N	\N	12
4940	554	2018-08-21	\N	\N	2	2	\N	\N	\N	12
4941	554	2018-08-22	\N	\N	2	2	\N	\N	\N	12
4834	555	2018-07-14	\N	\N	123	38	\N	\N	\N	12
4835	555	2018-07-15	\N	\N	0	0	\N	\N	\N	0
4942	554	2018-08-23	\N	\N	2	2	\N	\N	\N	12
4943	554	2018-08-24	\N	\N	2	2	\N	\N	\N	12
4944	554	2018-08-25	\N	\N	2	2	\N	\N	\N	12
4945	554	2018-08-26	\N	\N	0	0	\N	\N	\N	0
4946	554	2018-08-27	\N	\N	2	2	\N	\N	\N	12
4947	554	2018-08-28	\N	\N	2	2	\N	\N	\N	12
4842	555	2018-07-22	\N	\N	0	0	\N	\N	\N	0
4948	554	2018-08-29	\N	\N	2	2	\N	\N	\N	12
4949	554	2018-08-30	\N	\N	2	2	\N	\N	\N	12
4845	555	2018-07-25	\N	\N	123	38	\N	\N	\N	12
4846	555	2018-07-26	\N	\N	123	38	\N	\N	\N	12
4847	555	2018-07-27	\N	\N	123	38	\N	\N	\N	12
4848	555	2018-07-28	\N	\N	123	38	\N	\N	\N	12
4849	555	2018-07-29	\N	\N	0	0	\N	\N	\N	0
4850	555	2018-07-30	\N	\N	123	38	\N	\N	\N	12
4851	555	2018-07-31	\N	\N	123	38	\N	\N	\N	12
4852	555	2018-08-01	\N	\N	123	38	\N	\N	\N	12
4950	554	2018-08-31	\N	\N	2	2	\N	\N	\N	12
4951	554	2018-09-01	\N	\N	2	2	\N	\N	\N	12
4982	396	2018-06-27	\N	\N	0	0	\N	\N	\N	\N
4986	396	2018-06-29	\N	\N	0	0	\N	\N	\N	\N
4990	396	2018-07-01	\N	\N	0	0	\N	\N	\N	0
4994	396	2018-06-12	\N	\N	0	0	\N	\N	\N	\N
5002	396	2018-06-02	\N	\N	0	0	\N	\N	\N	\N
5006	396	2018-06-04	\N	\N	0	0	\N	\N	\N	\N
5010	396	2018-06-06	\N	\N	0	0	\N	\N	\N	\N
5013	396	2018-06-24	\N	\N	0	0	\N	\N	\N	0
5016	396	2018-06-09	\N	\N	0	0	\N	\N	\N	\N
4823	555	2018-07-03	123	38	123	38	\N	\N	\N	12
4824	555	2018-07-04	123	38	123	38	\N	\N	\N	12
4825	555	2018-07-05	123	38	123	38	\N	\N	\N	12
4826	555	2018-07-06	123	38	123	38	\N	\N	\N	12
4827	555	2018-07-07	123	38	123	38	\N	\N	\N	12
4829	555	2018-07-09	123	38	123	38	\N	\N	\N	12
4830	555	2018-07-10	123	38	123	38	\N	\N	\N	12
4831	555	2018-07-11	123	38	123	38	\N	\N	\N	12
4832	555	2018-07-12	123	38	123	38	\N	\N	\N	12
4833	555	2018-07-13	123	38	123	38	\N	\N	\N	12
5020	396	2018-06-11	\N	\N	0	0	\N	\N	\N	\N
5024	396	2018-06-13	\N	\N	0	0	\N	\N	\N	\N
5028	396	2018-06-15	\N	\N	0	0	\N	\N	\N	\N
5032	396	2018-06-19	\N	\N	0	0	\N	\N	\N	\N
5036	396	2018-06-23	\N	\N	0	0	\N	\N	\N	\N
5040	396	2018-06-27	\N	\N	0	0	\N	\N	\N	\N
4836	555	2018-07-16	\N	10	123	10	\N	\N	\N	12
4837	555	2018-07-17	\N	25	123	38	\N	\N	\N	12
4838	555	2018-07-18	\N	40	123	38	\N	\N	\N	12
4843	555	2018-07-23	\N	15	123	38	\N	\N	\N	12
4844	555	2018-07-24	\N	0	123	38	\N	\N	\N	12
4839	555	2018-07-19	\N	20	123	30	\N	\N	\N	12
4822	555	2018-07-02	123	38	123	38	\N	\N	\N	12
4840	555	2018-07-20	\N	34	123	38	\N	\N	\N	12
4841	555	2018-07-21	\N	0	123	38	\N	\N	\N	12
4952	396	2018-06-01	\N	\N	0	0	\N	\N	\N	\N
4953	396	2018-06-02	\N	\N	0	0	\N	\N	\N	\N
4954	396	2018-06-03	\N	\N	0	0	\N	\N	\N	0
4955	396	2018-06-04	\N	\N	0	0	\N	\N	\N	\N
4956	396	2018-06-05	\N	\N	0	0	\N	\N	\N	\N
4957	396	2018-06-06	\N	\N	0	0	\N	\N	\N	\N
4958	396	2018-06-07	\N	\N	0	0	\N	\N	\N	\N
4959	396	2018-06-08	\N	\N	0	0	\N	\N	\N	\N
4960	396	2018-06-09	\N	\N	0	0	\N	\N	\N	\N
4961	396	2018-06-10	\N	\N	0	0	\N	\N	\N	0
4962	396	2018-06-11	\N	\N	0	0	\N	\N	\N	\N
4963	396	2018-06-12	\N	\N	0	0	\N	\N	\N	\N
4964	396	2018-06-13	\N	\N	0	0	\N	\N	\N	\N
4965	396	2018-06-14	\N	\N	0	0	\N	\N	\N	\N
4966	396	2018-06-15	\N	\N	0	0	\N	\N	\N	\N
4967	396	2018-06-16	\N	\N	0	0	\N	\N	\N	\N
4968	396	2018-06-17	\N	\N	0	0	\N	\N	\N	0
4969	396	2018-06-18	\N	\N	0	0	\N	\N	\N	\N
4970	396	2018-06-19	\N	\N	0	0	\N	\N	\N	\N
4971	396	2018-06-20	\N	\N	0	0	\N	\N	\N	\N
4972	396	2018-06-21	\N	\N	0	0	\N	\N	\N	\N
4973	396	2018-06-22	\N	\N	0	0	\N	\N	\N	\N
4974	396	2018-06-23	\N	\N	0	0	\N	\N	\N	\N
4976	396	2018-06-24	\N	\N	0	0	\N	\N	\N	0
4979	396	2018-06-03	\N	\N	0	0	\N	\N	\N	0
4983	396	2018-06-05	\N	\N	0	0	\N	\N	\N	\N
4987	396	2018-06-07	\N	\N	0	0	\N	\N	\N	\N
4991	396	2018-06-09	\N	\N	0	0	\N	\N	\N	\N
4995	396	2018-06-13	\N	\N	0	0	\N	\N	\N	\N
4998	396	2018-06-16	\N	\N	0	0	\N	\N	\N	\N
5001	396	2018-06-18	\N	\N	0	0	\N	\N	\N	\N
5005	396	2018-06-20	\N	\N	0	0	\N	\N	\N	\N
5009	396	2018-06-22	\N	\N	0	0	\N	\N	\N	\N
5012	396	2018-06-07	\N	\N	0	0	\N	\N	\N	\N
5015	396	2018-06-25	\N	\N	0	0	\N	\N	\N	\N
5019	396	2018-06-27	\N	\N	0	0	\N	\N	\N	\N
5023	396	2018-06-29	\N	\N	0	0	\N	\N	\N	\N
5027	396	2018-07-01	\N	\N	0	0	\N	\N	\N	0
5031	396	2018-06-18	\N	\N	0	0	\N	\N	\N	\N
5035	396	2018-06-22	\N	\N	0	0	\N	\N	\N	\N
5039	396	2018-06-26	\N	\N	0	0	\N	\N	\N	\N
5043	396	2018-06-30	\N	\N	0	0	\N	\N	\N	\N
4975	396	2018-06-01	\N	\N	0	0	\N	\N	\N	\N
4978	396	2018-06-25	\N	\N	0	0	\N	\N	\N	\N
4981	396	2018-06-04	\N	\N	0	0	\N	\N	\N	\N
4985	396	2018-06-06	\N	\N	0	0	\N	\N	\N	\N
4989	396	2018-06-08	\N	\N	0	0	\N	\N	\N	\N
4993	396	2018-06-11	\N	\N	0	0	\N	\N	\N	\N
4997	396	2018-06-15	\N	\N	0	0	\N	\N	\N	\N
5000	396	2018-06-01	\N	\N	0	0	\N	\N	\N	\N
5004	396	2018-06-03	\N	\N	0	0	\N	\N	\N	0
5008	396	2018-06-05	\N	\N	0	0	\N	\N	\N	\N
5017	396	2018-06-26	\N	\N	0	0	\N	\N	\N	\N
5021	396	2018-06-28	\N	\N	0	0	\N	\N	\N	\N
5025	396	2018-06-30	\N	\N	0	0	\N	\N	\N	\N
5029	396	2018-06-16	\N	\N	0	0	\N	\N	\N	\N
5033	396	2018-06-20	\N	\N	0	0	\N	\N	\N	\N
5037	396	2018-06-24	\N	\N	0	0	\N	\N	\N	0
5041	396	2018-06-28	\N	\N	0	0	\N	\N	\N	\N
5044	396	2018-07-01	\N	\N	0	0	\N	\N	\N	0
4889	554	2018-07-01	\N	\N	0	0	\N	\N	\N	0
4903	554	2018-07-15	\N	\N	0	0	\N	\N	\N	0
4907	554	2018-07-19	\N	\N	2	2	\N	\N	\N	12
4908	554	2018-07-20	\N	\N	2	2	\N	\N	\N	12
4909	554	2018-07-21	\N	\N	2	2	\N	\N	\N	12
4910	554	2018-07-22	\N	\N	0	0	\N	\N	\N	0
4911	554	2018-07-23	\N	\N	2	2	\N	\N	\N	12
4912	554	2018-07-24	\N	\N	2	2	\N	\N	\N	12
4913	554	2018-07-25	\N	\N	2	2	\N	\N	\N	12
4914	554	2018-07-26	\N	\N	2	2	\N	\N	\N	12
4915	554	2018-07-27	\N	\N	2	2	\N	\N	\N	12
4916	554	2018-07-28	\N	\N	2	2	\N	\N	\N	12
4917	554	2018-07-29	\N	\N	0	0	\N	\N	\N	0
4918	554	2018-07-30	\N	\N	2	2	\N	\N	\N	12
4919	554	2018-07-31	\N	\N	2	2	\N	\N	\N	12
4920	554	2018-08-01	\N	\N	2	2	\N	\N	\N	12
4921	554	2018-08-02	\N	\N	2	2	\N	\N	\N	12
4922	554	2018-08-03	\N	\N	2	2	\N	\N	\N	12
4923	554	2018-08-04	\N	\N	2	2	\N	\N	\N	12
4924	554	2018-08-05	\N	\N	0	0	\N	\N	\N	0
4925	554	2018-08-06	\N	\N	2	2	\N	\N	\N	12
4926	554	2018-08-07	\N	\N	2	2	\N	\N	\N	12
4927	554	2018-08-08	\N	\N	2	2	\N	\N	\N	12
4928	554	2018-08-09	\N	\N	2	2	\N	\N	\N	12
4929	554	2018-08-10	\N	\N	2	2	\N	\N	\N	12
4930	554	2018-08-11	\N	\N	2	2	\N	\N	\N	12
4890	554	2018-07-02	3	2	2	2	\N	\N	\N	12
4891	554	2018-07-03	3	2	2	2	\N	\N	\N	12
4892	554	2018-07-04	2	2	2	2	\N	\N	\N	12
4893	554	2018-07-05	2	2	2	2	\N	\N	\N	12
4894	554	2018-07-06	1	2	2	2	\N	\N	\N	12
4895	554	2018-07-07	3	2	2	2	\N	\N	\N	12
4896	554	2018-07-08	2	2	0	0	\N	\N	\N	0
4897	554	2018-07-09	2	1	2	2	\N	\N	\N	12
4899	554	2018-07-11	2	3	2	2	\N	\N	\N	12
4898	554	2018-07-10	1	4	2	2	\N	\N	\N	12
4900	554	2018-07-12	1	2	2	2	\N	\N	\N	12
4901	554	2018-07-13	1	1	2	2	\N	\N	\N	12
4902	554	2018-07-14	\N	3	2	2	\N	\N	\N	12
4977	396	2018-06-02	\N	\N	0	0	\N	\N	\N	\N
4980	396	2018-06-26	\N	\N	0	0	\N	\N	\N	\N
4984	396	2018-06-28	\N	\N	0	0	\N	\N	\N	\N
4988	396	2018-06-30	\N	\N	0	0	\N	\N	\N	\N
4992	396	2018-06-10	\N	\N	0	0	\N	\N	\N	0
4996	396	2018-06-14	\N	\N	0	0	\N	\N	\N	\N
4999	396	2018-06-17	\N	\N	0	0	\N	\N	\N	0
5003	396	2018-06-19	\N	\N	0	0	\N	\N	\N	\N
5007	396	2018-06-21	\N	\N	0	0	\N	\N	\N	\N
5011	396	2018-06-23	\N	\N	0	0	\N	\N	\N	\N
5014	396	2018-06-08	\N	\N	0	0	\N	\N	\N	\N
5018	396	2018-06-10	\N	\N	0	0	\N	\N	\N	0
5022	396	2018-06-12	\N	\N	0	0	\N	\N	\N	\N
5026	396	2018-06-14	\N	\N	0	0	\N	\N	\N	\N
5030	396	2018-06-17	\N	\N	0	0	\N	\N	\N	0
5034	396	2018-06-21	\N	\N	0	0	\N	\N	\N	\N
5038	396	2018-06-25	\N	\N	0	0	\N	\N	\N	\N
5042	396	2018-06-29	\N	\N	0	0	\N	\N	\N	\N
4904	554	2018-07-16	\N	7	2	5	\N	\N	\N	12
4905	554	2018-07-17	\N	13	2	10	\N	\N	\N	12
4906	554	2018-07-18	\N	0	2	2	\N	\N	\N	12
\.


--
-- Name: activity_data_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('activity_data_id_seq', 5044, true);


--
-- Data for Name: activity_dependencies; Type: TABLE DATA; Schema: public; Owner: -
--

COPY activity_dependencies (id, activity_id, required_activity_id) FROM stdin;
1	554	475
3	554	537
\.


--
-- Name: activity_dependencies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('activity_dependencies_id_seq', 3, true);


--
-- Data for Name: bundle_activities; Type: TABLE DATA; Schema: public; Owner: -
--

COPY bundle_activities (bundle_id, activity_id, id) FROM stdin;
1	27	25
1	28	26
\.


--
-- Name: bundle_activities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('bundle_activities_id_seq', 8, true);


--
-- Name: bundle_activities_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('bundle_activities_id_seq1', 26, true);


--
-- Name: bundle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('bundle_id_seq', 20, true);


--
-- Data for Name: bundle_phases; Type: TABLE DATA; Schema: public; Owner: -
--

COPY bundle_phases (id, bundle_id, phase_id) FROM stdin;
1	1	4
2	13	4
3	14	4
4	11	4
5	12	4
6	15	2
7	18	5
8	19	1
9	20	3
\.


--
-- Name: bundle_phases_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('bundle_phases_id_seq', 9, true);


--
-- Data for Name: bundle_tasks; Type: TABLE DATA; Schema: public; Owner: -
--

COPY bundle_tasks ("int", bundle_id, task_id) FROM stdin;
1	16	1
2	16	2
3	17	3
4	17	4
\.


--
-- Name: bundle_tasks_int_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('bundle_tasks_int_seq', 4, true);


--
-- Data for Name: bundles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY bundles (id, parent_bundle_id, name, project_id, title, phase_id) FROM stdin;
15	\N	Engineering Activities	1	Activities	\N
16	\N	Contracts	1	Contracts	\N
17	\N	Permitting	1	Permitting	\N
18	\N	Testing	1	\N	\N
19	\N	Studies	1	Studies	\N
20	\N	Materials	1	\N	\N
1	\N	Block 1	1	Block	4
11	\N	Block 2	1	Block	4
12	\N	Block 3	1	Block	4
13	\N	Block 4	2	Block	4
14	\N	Block 5	2	Block	4
\.


--
-- Data for Name: change_orders; Type: TABLE DATA; Schema: public; Owner: -
--

COPY change_orders (id, project_id, contractor_id, description, approved_cost, estimted_cost, date_submitted, date_approved, percent_complete) FROM stdin;
\.


--
-- Data for Name: clients; Type: TABLE DATA; Schema: public; Owner: -
--

COPY clients (id, name, logo_url, dashboards, default_section) FROM stdin;
1	Deepak	http://cct-mckinsey.com/logo-deepak.png	{phases,construction.schedule,construction.safety}	phases
\.


--
-- Name: clients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('clients_id_seq', 4, true);


--
-- Data for Name: contractors; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contractors (name, email, phone, pm_contact, id) FROM stdin;
Contractor A	info@contractora.com	646-450-0364	\N	1
Contractor 2	\N	\N	\N	2
Xcel	\N	\N	\N	3
\.


--
-- Name: contractors_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('contractors_id_seq1', 3, true);


--
-- Data for Name: incident_classes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY incident_classes (id, name) FROM stdin;
1	Assault or violent act
2	Caught in, under or between
3	Confined space
4	Cut, puncture, scrape
5	Explosions or burns
6	Exposure electrical
7	Falls from height
8	Overexertion/strain
9	Pressure release
10	Slips and trips
11	Struck by
12	Water related, drowning
13	Other
\.


--
-- Data for Name: incident_types; Type: TABLE DATA; Schema: public; Owner: -
--

COPY incident_types (id, name) FROM stdin;
1	Site Visit
2	Near Miss
3	OSHA Recordable
4	Lost Time
\.


--
-- Data for Name: incidents; Type: TABLE DATA; Schema: public; Owner: -
--

COPY incidents (id, date, contractor_id, incident_type_id, incident_class_id, project_id) FROM stdin;
1	2017-09-01	1	1	1	1
2	2017-08-15	1	2	2	1
\.


--
-- Name: incidents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('incidents_id_seq', 2, true);


--
-- Data for Name: indirect_costs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY indirect_costs (id, actual_amount, planned_amount, project_id) FROM stdin;
\.


--
-- Data for Name: installations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY installations (id, item_id, date_installed, units_installed, units_failed, project_id) FROM stdin;
\.


--
-- Data for Name: invoices; Type: TABLE DATA; Schema: public; Owner: -
--

COPY invoices (id, activity_id, amount, date_invoiced) FROM stdin;
\.


--
-- Data for Name: issue_statuses; Type: TABLE DATA; Schema: public; Owner: -
--

COPY issue_statuses (id, name) FROM stdin;
\.


--
-- Data for Name: issues; Type: TABLE DATA; Schema: public; Owner: -
--

COPY issues (id, name, responsible, description, status, resolution, deadline, updated_by, updated, activity_id, issue_status_id) FROM stdin;
\.


--
-- Data for Name: items; Type: TABLE DATA; Schema: public; Owner: -
--

COPY items (id, name) FROM stdin;
\.


--
-- Data for Name: locations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY locations (street, city, state, country, latitude, longitude, id) FROM stdin;
9806 S Ohio Ave	Cantua Creek	CA	US	36.5828385000000011	-120.402474900000001	1
\N	Nipton	CA	US	35.5565665000000024	-115.473041199999997	2
Co Rd 0	Santa Margarita	CA	US	35.383337400000002	-120.0688557	3
General Petroleum Rd	Rosamond	CA	US	34.9391681999999975	-118.339379699999995	4
42134 Harper Lake Rd	Hinkley	CA	US	35.0127841999999987	-117.331456200000005	5
\.


--
-- Name: locations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('locations_id_seq', 1, true);


--
-- Name: locations_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('locations_id_seq1', 2, true);


--
-- Data for Name: materials; Type: TABLE DATA; Schema: public; Owner: -
--

COPY materials (id, name, vendor, external_id) FROM stdin;
74	Agitators	Enercare	\N
73	Chiller unit	Enercare	\N
75	Raw water treatment plant	Enercare	\N
76	Cooling tower package	Enercare	\N
77	Fire fighting package	Enercare	\N
78	DM plant	Enercare	\N
79	API pumps- CNA Plants	Enercare	\N
80	Air compressor	Enercare	\N
81	Air drier	Enercare	\N
82	Deareator	Enercare	\N
83	Boiler for CPP package	Enercare	\N
84	Inlet air filter	Enercare	\N
85	Non-API pumps- WNA Plant	Enercare	\N
86	Non-API pumps	Enercare	\N
87	Ejectors	Enercare	\N
88	Cooling water pumps	Enercare	\N
89	Side stream filter package	Enercare	\N
90	De-alkalizer (Deleted)	Enercare	\N
91	STG for CPP package	Enercare	\N
92	PFAlined pumps	Enercare	\N
93	Metering pumps	Enercare	\N
94	ETP package	Enercare	\N
95	Ammonia compressor	Enercare	\N
96	Chlorination package	Enercare	\N
97	Filters	Enercare	\N
98	Mist separator	Enercare	\N
99	Surface condenser pump	Enercare	\N
100	Rotary vane pumps	Enercare	\N
101	Platinum filter (Internals)	Enercare	\N
102	Ammonia transfer pumps	Enercare	\N
103	Extended shaft pumps	Enercare	\N
104	Desuperheater	Enercare	\N
105	Vacuum jet	Enercare	\N
106	Lube oil pumps	Enercare	\N
107	Non-metallic tanks	Enercare	\N
108	Safety shower/Eye wash	Enercare	\N
109	Packings/Internals	Enercare	\N
110	Lift (CNA)	Enercare	\N
111	Condensate transfer pumps	Enercare	\N
112	HVAC package	Enercare	\N
113	Mixer	Enercare	\N
114	Ammonia scrubber	Enercare	\N
115	Lube oil filters	Enercare	\N
116	Plate type exchangers (Deleted)	Enercare	\N
117	Loading arms	Enercare	\N
118	Flame arrestors (Deleted)	Enercare	\N
119	Breather valves (Deleted)	Enercare	\N
120	NG station (Deleted)	Enercare	\N
121	EOT Cranes	Enercare	\N
122	API pumps- Offsites & Utilites (Deleted)	Enercare	\N
123	Roof vent fan (Deleted)	Enercare	\N
124	Inlet air silencer (Deleted)	Enercare	\N
125	Chemical skids	Enercare	\N
126	Silica gel	Enercare	\N
127	Ammonia effluent transfer pumps (Mobile)	Enercare	\N
128	Soil testing	Enercare	\N
129	Boundary wall	Enercare	\N
130	Pre-fabricated structure	Enercare	\N
131	Piling work	Enercare	\N
132	Architectural work (Covered in Part I & II)	Enercare	\N
133	Industrial painting (Covered in Part I & II)	Enercare	\N
134	Roads & drain work (Covered in Part I & II)	Enercare	\N
135	Civil & structural work (Part-I)	Enercare	\N
136	Civil & structural work (Part-II)	Enercare	\N
137	Acid resistant tiling (Covered in Part-II)	Enercare	\N
138	Boiler precast chimney	Enercare	\N
139	Structural steel (Deleted)	Enercare	\N
140	Reinforcement steel (Deleted)	Enercare	\N
141	Cement (Deleted)	Enercare	\N
142	WNA Plant equipments	Enercare	\N
143	CNA Plant equipments	Enercare	\N
144	OSBL equipments	Enercare	\N
145	Absorber foundation bolt & template	Enercare	\N
146	Mechanical erection & piping	Enercare	\N
147	additional scope (MOM-078) equipments	Enercare	\N
148	Insulation	Enercare	\N
149	Pipes	Enercare	\N
150	Valves	Enercare	\N
151	Flanges	Enercare	\N
152	Fittings	Enercare	\N
153	Stud bolts	Enercare	\N
154	Steam traps	Enercare	\N
155	Gaskets	Enercare	\N
156	Expansion bellows	Enercare	\N
157	Strainers	Enercare	\N
158	Sight glass	Enercare	\N
159	Primary supports	Enercare	\N
160	Special supports	Enercare	\N
161	Compact substation	Enercare	\N
162	Construction power	Enercare	\N
163	Transformers	Enercare	\N
164	HT panel	Enercare	\N
165	HT PCC	Enercare	\N
166	NGR	Enercare	\N
167	HT cables	Enercare	\N
168	DG	Enercare	\N
169	UPS	Enercare	\N
170	VFD	Enercare	\N
171	LT PCC	Enercare	\N
172	MCC	Enercare	\N
173	Battery and battery charger	Enercare	\N
174	Buss duct	Enercare	\N
175	HT motors	Enercare	\N
176	APFC panel	Enercare	\N
177	LT motors	Enercare	\N
178	Local control stations	Enercare	\N
179	Control cables (Deleted)	Enercare	\N
180	Jointing kits (Deleted)	Enercare	\N
181	Lighting transformers (Deleted)	Enercare	\N
182	Cable tray	Enercare	\N
183	Earthing strips (Deleted)	Enercare	\N
184	Lightening arrestors (Deleted)	Enercare	\N
185	PA system	Enercare	\N
186	Switchyard (Deleted)	Enercare	\N
187	LT cables	Enercare	\N
188	HT Capacitor bank	Enercare	\N
189	EPBAX system	Enercare	\N
190	Electrical installation	Enercare	\N
191	Light fittings	Enercare	\N
192	CCTV	Enercare	\N
193	UMPS	Enercare	\N
194	Misc. panels	Enercare	\N
195	Electrical heat tracing	Enercare	\N
196	Weigh bridge	Enercare	\N
197	Ordering ofVibration montoring system	Enercare	\N
198	DCS system	Enercare	\N
199	Control valves- CNA Plants	Enercare	\N
200	On/Off valves- WNA Plant	Enercare	\N
201	On/Off valves- CNA Plants	Enercare	\N
202	On/Off valves- Offsites & Utilities	Enercare	\N
203	Flow meters- Offsites & Utilities	Enercare	\N
204	Control valves- Offsites & Utilities	Enercare	\N
205	Control valves- WNA Plant	Enercare	\N
206	Anti surge controller	Enercare	\N
207	Governor	Enercare	\N
208	Flow meters- WNA Plant	Enercare	\N
209	Flow meters- CNA Plants	Enercare	\N
210	Analysers/Gas detectors- CNA Plants	Enercare	\N
211	Analysers/Gas detectors- Offsites & Utilities	Enercare	\N
212	Analysers/Gas detectors- WNA Plant (Deleted)	Enercare	\N
213	Switches- WNA Plant (Deleted)	Enercare	\N
214	bulk materials (Deleted)	Enercare	\N
215	Cable trays	Enercare	\N
216	Instrument cables	Enercare	\N
217	Switches- CNA Plants (Deleted)	Enercare	\N
218	DIN Rail Transmitters- CNA Plant (Deleted)	Enercare	\N
219	Transmitters- WNA Plant	Enercare	\N
220	Saftey items- WNA Plant	Enercare	\N
221	Gauges- WNA Plant	Enercare	\N
222	Fire alarm system	Enercare	\N
223	Transmitters- CNA Plants	Enercare	\N
224	Transmitters- Offsites & Utilities	Enercare	\N
225	Saftey items- CNA Plants	Enercare	\N
226	Saftey items- Offsites & Utilities	Enercare	\N
227	Gauges- CNA Plants	Enercare	\N
228	Gauges- Offsites & Utilities	Enercare	\N
229	Junction boxes	Enercare	\N
230	Instrument installation	Enercare	\N
231	Switches- Offsites & Utilities	Enercare	\N
\.


--
-- Name: materials_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('materials_id_seq', 231, true);


--
-- Data for Name: milestones; Type: TABLE DATA; Schema: public; Owner: -
--

COPY milestones (name, actual, planned, contract, project_id, phase_id, id) FROM stdin;
Design Approved	\N	2018-03-01	2018-03-01	1	2	8
Issue Permission to Operate (PTO)	\N	2018-01-10	2018-01-10	1	5	9
Issue Meter Compliance Certificate	\N	2018-01-05	2018-01-05	1	5	10
Issue Commercial Operation Certificate	\N	2018-01-12	2018-01-12	1	5	11
Execute Lease	2017-01-01	2017-01-01	2017-01-01	1	3	12
Circuit Substantial - Circuit 1	\N	2017-12-03	2017-12-03	1	4	1
Circuit Substantial - Circuit 2	\N	2017-12-03	2017-12-03	1	4	2
Circuit Substantial - Circuit 3	\N	2017-12-03	2017-12-03	1	4	3
Circuit Substantial - Circuit 4	\N	2017-12-03	2017-12-03	1	4	4
Circuit Substantial - Circuit 5	\N	2017-12-03	2017-12-03	1	4	5
Circuit Substantial - Circuit 6	\N	2017-12-03	2017-12-03	1	4	6
Circuit Substantial - Circuit 7	\N	2018-03-01	2018-03-01	1	4	7
Kickoff Meeting	2016-08-01	2016-08-01	2016-08-01	1	1	13
\.


--
-- Name: milestones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('milestones_id_seq', 13, true);


--
-- Data for Name: ncrs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY ncrs (id, project_id, contractor_id, description, date_open, date_closed) FROM stdin;
\.


--
-- Name: new_table_0_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('new_table_0_id_seq', 5, true);


--
-- Name: new_table_0_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('new_table_0_id_seq1', 13, true);


--
-- Name: new_table_0_id_seq2; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('new_table_0_id_seq2', 1, false);


--
-- Name: new_table_1_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('new_table_1_id_seq', 1, false);


--
-- Data for Name: phases; Type: TABLE DATA; Schema: public; Owner: -
--

COPY phases (name, scheduled_start, scheduled_end, actual_start, actual_end, id, project_id, planned_start, planned_end) FROM stdin;
Origination	\N	\N	\N	\N	1	1	\N	\N
Engineering	\N	\N	\N	\N	2	1	\N	\N
Procurement	\N	\N	\N	\N	3	1	\N	\N
Construction	\N	\N	\N	\N	4	1	\N	\N
Commissioning	\N	\N	\N	\N	5	1	\N	\N
\.


--
-- Name: phases_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('phases_id_seq', 5, true);


--
-- Data for Name: portfolio_projects; Type: TABLE DATA; Schema: public; Owner: -
--

COPY portfolio_projects (id, portfolio_id, project_id) FROM stdin;
1	1	1
2	1	2
3	1	3
4	1	4
5	1	5
\.


--
-- Name: portfolio_projects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('portfolio_projects_id_seq', 5, true);


--
-- Data for Name: portfolios; Type: TABLE DATA; Schema: public; Owner: -
--

COPY portfolios (id, name) FROM stdin;
1	Test
\.


--
-- Name: portfolios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('portfolios_id_seq', 1, true);


--
-- Data for Name: procurements; Type: TABLE DATA; Schema: public; Owner: -
--

COPY procurements (id, name, date_needed, date_delivered, project_id, item_id) FROM stdin;
\.


--
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: -
--

COPY projects (id, name, start, "end", workdays, budget, bundle_title, location_id, contingency) FROM stdin;
1	DFPC Nitric Acid Complex	2017-08-21	2018-01-30	[1,2,3,4,5]	1000000	Blocks	1	\N
\.


--
-- Name: projects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('projects_id_seq', 5, true);


--
-- Data for Name: task_history; Type: TABLE DATA; Schema: public; Owner: -
--

COPY task_history (id, task_id, description, created, updated, hours) FROM stdin;
\.


--
-- Name: task_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('task_history_id_seq', 1, false);


--
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: -
--

COPY tasks (id, name, actual_start, actual_end, planned_start, planed_end, contractor_id, percent_complete, updated, created) FROM stdin;
1	Contract 1	\N	2018-01-05	\N	2018-01-01	\N	\N	\N	\N
2	Contract 2	\N	\N	\N	\N	\N	\N	\N	\N
3	Permit 1	\N	\N	\N	\N	\N	\N	\N	\N
4	Permit 2	\N	\N	\N	\N	\N	\N	\N	\N
\.


--
-- Name: tasks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('tasks_id_seq', 4, true);


--
-- Data for Name: units; Type: TABLE DATA; Schema: public; Owner: -
--

COPY units (id, name) FROM stdin;
1	feet
2	sq ft
3	units
\.


--
-- Data for Name: variance_reasons; Type: TABLE DATA; Schema: public; Owner: -
--

COPY variance_reasons (id, name) FROM stdin;
\.


--
-- Data for Name: variances; Type: TABLE DATA; Schema: public; Owner: -
--

COPY variances (id, activity_id, reported_date, updated_date, reason_id, comment) FROM stdin;
\.


--
-- Data for Name: weightings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY weightings (id, score, weighting) FROM stdin;
\.


--
-- Name: activities activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (id);


--
-- Name: activity_data activity_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY activity_data
    ADD CONSTRAINT activity_data_pkey PRIMARY KEY (id, activity_id);


--
-- Name: activity_dependencies activity_dependencies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY activity_dependencies
    ADD CONSTRAINT activity_dependencies_pkey PRIMARY KEY (id);


--
-- Name: bundle_activities bundle_activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bundle_activities
    ADD CONSTRAINT bundle_activities_pkey PRIMARY KEY (id);


--
-- Name: bundle_phases bundle_phases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bundle_phases
    ADD CONSTRAINT bundle_phases_pkey PRIMARY KEY (id);


--
-- Name: bundles bundle_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bundles
    ADD CONSTRAINT bundle_pkey PRIMARY KEY (id);


--
-- Name: bundle_tasks bundle_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bundle_tasks
    ADD CONSTRAINT bundle_tasks_pkey PRIMARY KEY ("int");


--
-- Name: clients clients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


--
-- Name: contractors contractors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contractors
    ADD CONSTRAINT contractors_pkey PRIMARY KEY (id);


--
-- Name: incidents incidents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY incidents
    ADD CONSTRAINT incidents_pkey PRIMARY KEY (id);


--
-- Name: materials materials_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY materials
    ADD CONSTRAINT materials_pkey PRIMARY KEY (id);


--
-- Name: milestones milestones_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY milestones
    ADD CONSTRAINT milestones_pkey PRIMARY KEY (id);


--
-- Name: units new_table_0_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY units
    ADD CONSTRAINT new_table_0_pkey PRIMARY KEY (id);


--
-- Name: change_orders new_table_0_pkey1; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY change_orders
    ADD CONSTRAINT new_table_0_pkey1 PRIMARY KEY (id);


--
-- Name: variance_reasons new_table_0_pkey10; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY variance_reasons
    ADD CONSTRAINT new_table_0_pkey10 PRIMARY KEY (id);


--
-- Name: incident_types new_table_0_pkey11; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY incident_types
    ADD CONSTRAINT new_table_0_pkey11 PRIMARY KEY (id);


--
-- Name: incident_classes new_table_0_pkey12; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY incident_classes
    ADD CONSTRAINT new_table_0_pkey12 PRIMARY KEY (id);


--
-- Name: procurements new_table_0_pkey2; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY procurements
    ADD CONSTRAINT new_table_0_pkey2 PRIMARY KEY (id);


--
-- Name: installations new_table_0_pkey3; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY installations
    ADD CONSTRAINT new_table_0_pkey3 PRIMARY KEY (id);


--
-- Name: ncrs new_table_0_pkey4; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ncrs
    ADD CONSTRAINT new_table_0_pkey4 PRIMARY KEY (id);


--
-- Name: weightings new_table_0_pkey6; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY weightings
    ADD CONSTRAINT new_table_0_pkey6 PRIMARY KEY (id);


--
-- Name: issues new_table_0_pkey8; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY issues
    ADD CONSTRAINT new_table_0_pkey8 PRIMARY KEY (id);


--
-- Name: variances new_table_0_pkey9; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY variances
    ADD CONSTRAINT new_table_0_pkey9 PRIMARY KEY (id);


--
-- Name: issue_statuses new_table_1_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY issue_statuses
    ADD CONSTRAINT new_table_1_pkey PRIMARY KEY (id);


--
-- Name: phases phases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY phases
    ADD CONSTRAINT phases_pkey PRIMARY KEY (id);


--
-- Name: indirect_costs pk_indirect_costs_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY indirect_costs
    ADD CONSTRAINT pk_indirect_costs_id PRIMARY KEY (id);


--
-- Name: invoices pk_invoices_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY invoices
    ADD CONSTRAINT pk_invoices_id PRIMARY KEY (id);


--
-- Name: items pk_items_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY items
    ADD CONSTRAINT pk_items_id PRIMARY KEY (id);


--
-- Name: portfolio_projects portfolio_projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY portfolio_projects
    ADD CONSTRAINT portfolio_projects_pkey PRIMARY KEY (id);


--
-- Name: portfolios portfolios_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY portfolios
    ADD CONSTRAINT portfolios_pkey PRIMARY KEY (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- Name: ac; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ac ON activity_data USING btree (activity_id, date);


--
-- Name: activity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX activity ON activity_data USING btree (activity_id);


--
-- Name: ag; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ag ON activity_data USING btree (activity_id, actual_hours, actual_units, planned_hours, planned_units);


--
-- Name: phase; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX phase ON activities USING btree (phase_id);


--
-- Name: t1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX t1 ON bundles USING btree (project_id);


--
-- Name: t2; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX t2 ON bundle_activities USING btree (bundle_id, activity_id);


--
-- Name: public; Type: ACL; Schema: -; Owner: -
--

REVOKE ALL ON SCHEMA public FROM cloudsqladmin;
REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO cloudsqlsuperuser;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

