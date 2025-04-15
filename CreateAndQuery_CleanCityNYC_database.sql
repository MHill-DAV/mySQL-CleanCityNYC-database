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

-- 	QUERIES --

-- 1. What is the most common sanitation-related 311 complaint in each community district?

SELECT
  cdta.cdta_description,
  ct.complaint_type,
  COUNT(*) AS total_complaints
FROM service_request sr
JOIN community_district_tabulation_area cdta ON sr.cdta_id = cdta.cdta_id
JOIN complaint_type ct ON sr.complaint_type_id = ct.complaint_type_id
GROUP BY sr.cdta_id, ct.complaint_type, cdta.cdta_description
HAVING COUNT(*) = (
  SELECT MAX(c)
  FROM (
    SELECT COUNT(*) AS c
    FROM service_request sr2
    WHERE sr2.cdta_id = sr.cdta_id
    GROUP BY sr2.complaint_type_id
  ) AS counts
)
ORDER BY cdta.cdta_description;

-- 2. What is the most common complaint in majority Black community districts?

SELECT
  cdta.cdta_description,
  ct.complaint_type,
  COUNT(*) AS total_complaints
FROM service_request sr
JOIN community_district_tabulation_area cdta ON sr.cdta_id = cdta.cdta_id
JOIN complaint_type ct ON sr.complaint_type_id = ct.complaint_type_id
WHERE cdta.cdta_id IN (
  SELECT cdta_id
  FROM cdta_population_demographic pop
  JOIN census_race_group r ON pop.census_race_code_id = r.census_race_code_id
  WHERE r.group_name = 'Black or African American alone'
  GROUP BY cdta_id
  HAVING SUM(pop.population_by_race) > (
    SELECT SUM(pop2.population_by_race)
    FROM cdta_population_demographic pop2
    WHERE pop2.cdta_id = pop.cdta_id
  ) / 2
)
GROUP BY cdta.cdta_id, ct.complaint_type
ORDER BY cdta.cdta_id, total_complaints DESC;

-- 3. What is the average number of complaints for districts WITH a waste center?

SELECT
  AVG(sub.total_requests) AS avg_complaints_with_waste_center
FROM (
  SELECT cdta.cdta_id, COUNT(*) AS total_requests
  FROM service_request sr
  JOIN community_district_tabulation_area cdta ON sr.cdta_id = cdta.cdta_id
  WHERE cdta.cdta_id IN (
    SELECT c.cdta_id
    FROM transfer_waste_station t
    JOIN dsny_district d ON t.dsny_district_id = d.dsny_district_id
    JOIN community_district_tabulation_area c ON d.cdta_id = c.cdta_id
  )
  GROUP BY cdta.cdta_id
) sub;

-- 4. What is the average number of complaints for districts WITHOUT a waste center?

SELECT
  AVG(sub.total_requests) AS avg_complaints_without_waste_center
FROM (
  SELECT cdta.cdta_id, COUNT(*) AS total_requests
  FROM service_request sr
  JOIN community_district_tabulation_area cdta ON sr.cdta_id = cdta.cdta_id
  WHERE cdta.cdta_id NOT IN (
    SELECT c.cdta_id
    FROM transfer_waste_station t
    JOIN dsny_district d ON t.dsny_district_id = d.dsny_district_id
    JOIN community_district_tabulation_area c ON d.cdta_id = c.cdta_id
  )
  GROUP BY cdta.cdta_id
) sub;

-- 5. Which districts have the highest median household income and how many complaints do they receive?

SELECT
  cdta.cdta_description,
  m.median_hh_income,
  COUNT(sr.service_request_id) AS total_complaints
FROM community_district_tabulation_area cdta
JOIN median_household_income m ON cdta.cdta_id = m.cdta_id
LEFT JOIN service_request sr ON cdta.cdta_id = sr.cdta_id
GROUP BY cdta.cdta_id, m.median_hh_income
ORDER BY m.median_hh_income DESC
LIMIT 10;

-- 6. Which complaint types are most common in districts with high population density?

SELECT
  cdta.cdta_description,
  ct.complaint_type,
  COUNT(*) AS complaint_count
FROM service_request sr
JOIN complaint_type ct ON sr.complaint_type_id = ct.complaint_type_id
JOIN community_district_tabulation_area cdta ON sr.cdta_id = cdta.cdta_id
WHERE cdta.cdta_id IN (
  SELECT cdta_id
  FROM cdta_population_demographic
  GROUP BY cdta_id
  HAVING SUM(population_by_race) > 200000 -- customize threshold
)
GROUP BY cdta.cdta_id, ct.complaint_type
ORDER BY complaint_count DESC;

-- 7. What is the most common complaint in majority Black community districts?

SELECT
  cdta.cdta_description,
  ct.complaint_type,
  COUNT(*) AS total_complaints
FROM service_request sr
JOIN community_district_tabulation_area cdta ON sr.cdta_id = cdta.cdta_id
JOIN complaint_type ct ON sr.complaint_type_id = ct.complaint_type_id
WHERE cdta.cdta_id IN (
  SELECT cdta_id
  FROM cdta_population_demographic pop
  JOIN census_race_group r ON pop.census_race_code_id = r.census_race_code_id
  WHERE r.group_name = 'Black or African American alone'
  GROUP BY cdta_id
  HAVING SUM(pop.population_by_race) > (
    SELECT SUM(pop2.population_by_race)
    FROM cdta_population_demographic pop2
    WHERE pop2.cdta_id = pop.cdta_id
  ) / 2
)
GROUP BY cdta.cdta_id, ct.complaint_type
ORDER BY cdta.cdta_id, total_complaints DESC;

-- 8. Do lower-income districts have fewer public litter baskets than higher-income ones?

SELECT
  CASE
    WHEN lb_districts.cdta_id IS NOT NULL THEN 'With Litter Baskets'
    ELSE 'Without Litter Baskets'
  END AS has_baskets,
  ROUND(AVG(m.median_hh_income), 2) AS avg_median_income,
  COUNT(DISTINCT cdta.cdta_id) AS num_districts
FROM community_district_tabulation_area cdta
JOIN median_household_income m ON cdta.cdta_id = m.cdta_id
LEFT JOIN (
    SELECT DISTINCT dd.cdta_id
    FROM litter_basket lb
    JOIN dsny_section ds ON lb.dsny_section_id = ds.dsny_section_id
    JOIN dsny_district dd ON ds.dsny_district_id = dd.dsny_district_id
) lb_districts ON lb_districts.cdta_id = cdta.cdta_id
GROUP BY
  CASE
    WHEN lb_districts.cdta_id IS NOT NULL THEN 'With Litter Baskets'
    ELSE 'Without Litter Baskets'
  END;
  
-- OTHER TASKS --

-- UPDATE DATA

#update the closed_date of a service_request with a date
UPDATE service_request
SET closed_date = '2022-05-07 16:00:00' WHERE closed_date IS NULL
ORDER BY created_date DESC
LIMIT 1;

-- ADD DATA 

-- transaction: Add a new census race group to the database
#START TRANSACTION:
INSERT INTO census_race_group (census_race_code, group_name, description) VALUES ('4omRNH', 'Four or more races non Hispanic');
COMMIT;

-- Create a trigger: sets a timestamp when a new row is inserted into the litter_basket table, allowing tracking of when litter baskets are added
CREATE TRIGGER add_created_at BEFORE INSERT ON litter_basket FOR EACH ROW
SET NEW.created_at = NOW();
  







 























