# CleanCityNYC

CleanCityNYC is a MySQL database project exploring the relationship between NYC community district demographics, 
sanitation infrastructure, and 311 complaint data.

## Entity-Relationship Diagram

![CleanCityNYC ERD](logical_erd_CleanCityNYC.png)

### Note: This is a practice SQL database that uses sample 311 data from 2023 in order to demonstrate database functionality.

This project creates a database of community district socioeconomic data, sanitation infrastructure, and 311 complaints. It allows users to access, compare, and analyze information typically spread across various datasets. With this database, potential users such as city planners, journalists, and urban researchers can pull data to analyze the relationship between neighborhood demographics and sanitation infrastructure, compare city services across various geographies, or simply understand the distribution of sanitation-related service requests throughout the city. Whether for exploratory insight or more formal statistical modeling, this schema opens the door for multi-layered analysis.

**Example queries explored in this project:**

- What is the most common sanitation-related 311 complaint in each community district?
- What is the most common complaint in majority Black community districts?
- What is the average number of complaints for districts *with* a waste center?
- What is the average number of complaints for districts *without* a waste center?
- Which districts have the highest median household income and how many complaints do they receive?
- Which complaint types are most common in districts with high population density?
- What is the most common complaint in majority Black community districts?
- Do lower-income districts have fewer public litter baskets than higher-income ones?




