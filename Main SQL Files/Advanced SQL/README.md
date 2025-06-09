## Introduction
This project takes a dive into the data analytics job market! Using real world job postings data we can see which skills statistically are most optimal and what the different skills look like for different roles. Based on my background, I am most interested in the job postings that are for Data Analyst and Business Analyst positions. The data analyzed in this project will be especially useful to anyone who is interested in a potential career in the data industry!
SQL Queries [project_sql folder](/project_sql/)
## Background
All of the data used in the project comes from 4 CSV tables from https://www.lukebarousse.com/products/sql-for-data-analytics. An advanced data analytics boot-camp that I have been utilizing to upskill my analytics.

The 5 focus questions that are answered are as follows.
-What are the top paying relevant jobs?

-What are the required skills for the top paying relevant jobs?

-What are the top demanded skills for relevant jobs?

-What are the highest paid skills for relevant jobs?

-What are the most optimal skills to learn for relevant jobs?

(NOTE)-Relavant jobs consist of those that have the following conditions
-Job title includes 'Data Analyst' or 'Business Analyst'
-Job posting includes salary information
-Job posting is not for a remote position
-Job posting is in the United States

## Tools Used
I utilized three tools for this data analysis

-**PostgreSQL** (a powerful, open source object-relational database system that relies on the coding language SQL)
-**Visual Studio Code** (VS Code is an integrated cross platform development environment)
-**Git & Github** (A popular version control system for software development. Allowing you to manage different versions of code within a repository)

## Analyis
### 1. Top Paying Roles
Question - What are the top paying business analyst and data analyst jobs?
Specifically the top 10 roles that are on site and only includes those that do not contain a null yearly rate.
```sql
SELECT 
    name AS company_name,
    job_id,
    job_title_short,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    (job_title_short = 'Data Analyst' OR job_title_short = 'Business Analyst')
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = 'False'
    AND job_country = 'United States'
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```
![Results Q1](Main SQL Files\Advanced SQL\Assets\Query1.png)
## What I learned
## Conclusion

