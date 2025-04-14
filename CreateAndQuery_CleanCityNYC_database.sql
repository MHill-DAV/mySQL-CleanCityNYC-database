#create database
CREATE DATABASE cdta_service_request_profile;

CREATE TABLE borough (
    borough_id INT NOT NULL AUTO_INCREMENT,
    borough_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (borough_id)
);

CREATE TABLE community_district_tabulation_area (
  cdta_id INT PRIMARY KEY AUTO_INCREMENT,
  cdta_code VARCHAR(10) NOT NULL,
  cdta_description VARCHAR(255),
  borough_id INT NOT NULL,
  FOREIGN KEY (borough_id) REFERENCES borough(borough_id) ON DELETE NO ACTION ON UPDATE NO ACTION
);


CREATE TABLE census_race_group (
  census_race_code_id INT PRIMARY KEY AUTO_INCREMENT,
  census_race_code VARCHAR(30) NOT NULL,
  group_name VARCHAR(50) NOT NULL,
  description VARCHAR(200)
);

CREATE TABLE cdta_population_demographic (
  cdta_population_demograpic_id INT PRIMARY KEY AUTO_INCREMENT,
  cdta_id INT NOT NULL,
  cdta_total_pop INT NOT NULL,
  census_race_code_id INT NOT NULL,
  population_by_race INT NOT NULL,
  source_year YEAR NOT NULL,
  FOREIGN KEY (cdta_id) REFERENCES community_district_tabulation_area(cdta_id) ON UPDATE NO ACTION ON DELETE NO ACTION,
  FOREIGN KEY (census_race_code_id) REFERENCES census_race_group(census_race_code_id) ON UPDATE CASCADE ON DELETE NO ACTION
);


CREATE TABLE median_household_income (
  median_hh_income_id INT NOT NULL AUTO_INCREMENT,
  median_hh_income DECIMAL(10,2) NOT NULL,
  date_reported YEAR NOT NULL,
  cdta_id INT NOT NULL,
  PRIMARY KEY (median_hh_income_id),
  FOREIGN KEY (cdta_id) REFERENCES community_district_tabulation_area(cdta_id) ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE dsny_district (
  dsny_district_id INT PRIMARY KEY AUTO_INCREMENT,
  dsny_district_code VARCHAR(10) NOT NULL,
  cdta_id INT NOT NULL,
  FOREIGN KEY (cdta_id) REFERENCES community_district_tabulation_area(cdta_id)
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);


CREATE TABLE transfer_waste_station (
    transfer_waste_station_id INT PRIMARY KEY auto_increment,
    facility_name VARCHAR(255) NOT NULL,
    owner_name VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    dsny_district_id INT,
    FOREIGN KEY (dsny_district_id) REFERENCES dsny_district(dsny_district_id)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);


CREATE TABLE dsny_section (
  dsny_section_id INT PRIMARY KEY AUTO_INCREMENT,
  dsny_section_code VARCHAR(10) NOT NULL,
  dsny_district_id INT NOT NULL,
  FOREIGN KEY (dsny_district_id) REFERENCES dsny_district(dsny_district_id) ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE litter_basket (
  litter_basket_id INT PRIMARY KEY AUTO_INCREMENT,
  basket_id INT,
  dsny_section_id INT NOT NULL,
  FOREIGN KEY (dsny_section_id)
    REFERENCES dsny_section(dsny_section_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

ALTER TABLE litter_basket
ADD COLUMN created_at TIMESTAMP DEFAULT NULL;

CREATE TRIGGER add_created_at
BEFORE INSERT ON litter_basket
FOR EACH ROW
SET NEW.created_at = NOW();



CREATE TABLE refuse_collection_frequency_code (
  frequency_code VARCHAR(1) NOT NULL PRIMARY KEY,
  description VARCHAR(255) NOT NULL
);


CREATE TABLE section_refuse_collection_frequency (
  collection_frequency_id INT AUTO_INCREMENT PRIMARY KEY,
  dsny_section_id INT NOT NULL,
  frequency_code VARCHAR(1) NOT NULL,
  FOREIGN KEY (dsny_section_id) REFERENCES dsny_section (dsny_section_id)
  ON UPDATE NO ACTION ON DELETE NO ACTION,
  FOREIGN KEY (frequency_code) REFERENCES refuse_collection_frequency_code (frequency_code)
  ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE agency (
    agency_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    agency_name VARCHAR(255) NOT NULL,
    acronym VARCHAR(50) NOT NULL,
    description TEXT
);

CREATE TABLE complaint_type (
  complaint_type_id INT PRIMARY KEY AUTO_INCREMENT,
  complaint_type VARCHAR(255) NOT NULL,
  complaint_type_description TEXT
);

CREATE TABLE descriptor (
  descriptor_id INT PRIMARY KEY auto_increment,
  descriptor_name VARCHAR(255) NOT NULL,
  complaint_type_id INT NOT NULL,
  FOREIGN KEY (complaint_type_id) REFERENCES complaint_type(complaint_type_id) 
  ON UPDATE NO ACTION ON DELETE NO ACTION
);
#ALTER TABLE descriptor
#MODIFY descriptor_id INT AUTO_INCREMENT;

CREATE TABLE service_request (
  service_request_id INT PRIMARY KEY auto_increment,
  unique_key INT,
  created_date DATETIME NOT NULL,
  closed_date DATETIME,
  cdta_id INT NOT NULL,
  agency_id INT NOT NULL,
  complaint_type_id INT NOT NULL,
  FOREIGN KEY (cdta_id) REFERENCES community_district_tabulation_area (cdta_id) ON UPDATE NO ACTION ON DELETE NO ACTION,
  FOREIGN KEY (agency_id) REFERENCES agency (agency_id) ON UPDATE NO ACTION ON DELETE NO ACTION,
  FOREIGN KEY (complaint_type_id) REFERENCES complaint_type (complaint_type_id) ON UPDATE NO ACTION ON DELETE NO ACTION
);


#ADD DATA
INSERT INTO borough (borough_name) VALUES 
('Bronx'),
('Brooklyn'),
('Manhattan'),
('Queens'),
('Staten Island');

#total_pop
/*INSERT INTO cdta_total_pop (total_pop, cdta_id, year)
VALUES 
    (201377, 1, 2021),
    (125740, 2, 2021),
    (181522, 3, 2021),
    (118143, 4, 2021),
    (204399, 5, 2021),
    (123369, 6, 2021),
    (126085, 7, 2021),
    (111533, 8, 2021),
    (100357, 9, 2021),
    (130654, 10, 2021),
    (196816, 11, 2021),
    (193089, 12, 2021),
    (112519, 13, 2021),
    (165478, 14, 2021),
    (164570, 15, 2021),
    (89142, 16, 2021),
    (158988, 17, 2021),
    (208559, 18, 2021),
    (0, 19, 2021),
    (20, 20, 2021),
    (97502, 21, 2021),
    (54904, 22, 2021),
    (89471, 23, 2021),
    (154943, 24, 2021),
    (138214, 25, 2021),
    (86349, 26, 2021),
    (145371, 27, 2021),
    (109962, 28, 2021),
    (175231, 29, 2021),
    (130956, 30, 2021),
    (121138, 31, 2021),
    (169246, 32, 2021),
    (0, 33, 2021),
    (15, 34, 2021),
    (52, 35, 2021),
    (72255, 36, 2021),
    (87858, 37, 2021),
    (157101, 38, 2021),
    (117930, 39, 2021),
    (49302, 40, 2021),
    (149052, 41, 2021),
    (221646, 42, 2021),
    (217279, 43, 2021),
    (115788, 44, 2021),
    (133831, 45, 2021),
    (126338, 46, 2021),
    (208994, 47, 2021),
    (0, 48, 2021),
    (179025, 49, 2021),
    (123037, 50, 2021),
    (161648, 51, 2021),
    (177666, 52, 2021),
    (190915, 53, 2021),
    (122786, 54, 2021),
    (253104, 55, 2021),
    (160231, 56, 2021),
    (151879, 57, 2021),
    (143380, 58, 2021),
    (126110, 59, 2021),
    (260024, 60, 2021),
    (214163, 61, 2021),
    (135784, 62, 2021),
    (135784, 62, 2021),
    (0, 63, 2021),
    (0, 64, 2021),
    (0, 66, 2021),
    (13, 67, 2021),
    (179530, 68, 2021),
    (170110, 70, 2021),
    (785, 71, 2021);*/

#census_race_group
INSERT INTO census_race_group (census_race_code, group_name)
VALUES ('Hsp1', 'Hispanic/Latino (of any race)'),
       ('NHsp', 'Not Hispanic/Latino'),
       ('WtNH', 'White alone'),
       ('BlNH', 'Black or African American alone'),
       ('AIANNH', 'American Indian and Alaska Native alone'),
       ('AsnNH', 'Asian alone'),
       ('NHPINH', 'Native Hawaiian and Other Pacific Islander alone'),
       ('OthNH', 'Some other race alone'),
       ('Rc2plNH', 'Two or more races');
       
#refuse collection freqency code
INSERT INTO refuse_collection_frequency_code (frequency_code, description)
VALUES
('A', 'Mon, Wed'),
('B', 'Tue, Thu, Sat'),
('C', 'Mon, Thu'),
('D', 'Tue, Fri'),
('E', 'Wed, Sat');

#agency
INSERT INTO agency (agency_name, acronym) VALUES 
('Administrative Justice Coordinator', 'AJC'),
('NYC Aging', 'NYC Aging'),
('Department of Buildings', 'DOB'),
('Department of City Planning', 'DOP'),
('Department of Consumer Affairs', 'DCA'),
('Department of Education', 'DOE'),
('Department of Environmental Protection', 'DEP'),
('Department of Finance', 'DOF'),
('Department of Health and Mental Hygiene', 'DOMH'),
('Department of Homeless Services', 'DHS'),
('Department of Parks and Recreation', 'DPR'),
('Department of Sanitation', 'DSNY'),
('Department of Transportation', 'DOT'),
('Economic Development Corporation', 'NYCEDC'),
('Human Resources Administration', 'HRA'),
('New York City Fire Department', 'FDNY'),
('New York City Police Department', 'NYPD'),
('NYC Emergency Management', 'NYCEM'),
('Office of Technology and Innovation', 'OTI'),
('Taxi and Limousine Commission', 'TLC');

#complaint_type
INSERT INTO complaint_type (complaint_type, complaint_type_description) VALUES 
('Abandoned Bike', NULL),
('Adopt-A-Basket', NULL),
('Collection Truck Noise', NULL),
('Commercial Disposal Complaint', NULL),
('Dead Animal', NULL),
('Derelict Bicycle', NULL),
('Derelict Vehicles', NULL),
('Dirty Condition', NULL),
('Dirty Conditions', NULL),
('DSNY Internal', NULL),
('DSNY Spillage', NULL),
('Dumpster Complaint', NULL),
('Electronics Waste', NULL),
('Electronics Waste Appointment', NULL),
('Employee Behavior', NULL),
('Foam Ban Enforcement', NULL),
('Graffiti', NULL),
('Illegal Dumping', NULL),
('Illegal Posting', NULL),
('Incorrect Data', NULL),
('Institution Disposal Complaint', NULL),
('Literature Request', NULL),
('Litter Basket / Request', NULL),
('Litter Basket Complaint', NULL),
('Litter Basket Request', NULL),
('Lot Condition', NULL),
('Missed Collection', NULL),
('Missed Collection (All Materials)', NULL),
('Obstruction', NULL),
('Oil or Gas Spill', NULL),
('Other Enforcement', NULL),
('Overflowing Litter Baskets', NULL),
('Overflowing Recycling Baskets', NULL),
('Recycling Basket Complaint', NULL),
('Recycling Enforcement', NULL),
('Request Changes - A.S.P.', NULL),
('Request Large Bulky Item Collection', NULL),
('Request Xmas Tree Collection', NULL),
('Residential Disposal Complaint', NULL),
('Retailer Complaint', NULL),
('Sanitation Condition', NULL),
('Sanitation Worker or Vehicle Complaint', NULL),
('Seasonal Collection', NULL),
('Snow', NULL),
('Snow or Ice', NULL),
('Snow Removal', NULL),
('Standpipe - Mechanical', NULL),
('Storm', NULL),
('Street Sweeping Complaint', NULL),
('Sweeping/Inadequate', NULL),
('Sweeping/Missed', NULL),
('Sweeping/Missed-Inadequate', NULL),
('Transfer Station Complaint', NULL),
('Vacant Lot', NULL),
('Vendor Enforcement', NULL);



#VIEWS
#cdta_request_profile
CREATE VIEW cdta_request_profile AS
SELECT
  c.cdta_code AS community_district_tabulation_area,
  COUNT(*) AS total_service_requests,
  MIN(sr.created_date) AS earliest_request_date,
  MAX(sr.closed_date) AS latest_closed_date,
  ct.complaint_type AS complaint_type,
  m.median_hh_income AS median_household_income,
  p.population_by_race AS population_by_race,
  r.group_name AS race_group
FROM
  service_request sr
  JOIN community_district_tabulation_area c ON sr.cdta_id = c.cdta_id
  JOIN complaint_type ct ON sr.complaint_type_id = ct.complaint_type_id
  LEFT JOIN median_household_income m ON sr.cdta_id = m.cdta_id
  LEFT JOIN cdta_population_demographic p ON sr.cdta_id = p.cdta_id
  LEFT JOIN census_race_group r ON p.census_race_code_id = r.census_race_code_id
GROUP BY
  sr.cdta_id,
  ct.complaint_type,
  m.median_hh_income,
  p.population_by_race,
  r.group_name;

#cdta pop by race percentage
CREATE VIEW cdta_pop_race_percentage AS
SELECT
c.cdta_id,
c.cdta_description,
ROUND((p1.population_by_race / p2.cdta_total_pop)*100, 2) AS race_percentage,
r.group_name
FROM
community_district_tabulation_area c
JOIN
cdta_population_demographic p1 ON c.cdta_id = p1.cdta_id
JOIN
cdta_population_demographic p2 ON c.cdta_id = p2.cdta_id AND p2.census_race_code_id IS NULL
JOIN
census_race_group r ON p1.census_race_code_id = r.census_race_code_id
WHERE
p1.census_race_code_id IS NOT NULL;


 























