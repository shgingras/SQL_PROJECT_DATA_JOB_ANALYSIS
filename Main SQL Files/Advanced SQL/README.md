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
### 2. Top Paying Skills
Question - What are the skills required for the top paying jobs?
Specifically which skills are listed for the top relevant data analyst and business analyst roles?
```sql
WITH top_paying_jobs AS (
SELECT 
    name AS company_name,
    job_id,
    job_title_short,
    salary_year_avg
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
LIMIT 10)
SELECT 
top_paying_jobs.*,
skills_dim.skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
salary_year_avg DESC;
```
![Results Q2](Main SQL Files\Advanced SQL\Assets\Query2.png)

### 3. Top Demanded Skills
Question - What are the most in demand skills for data analysts and business analysts?
Similar to the top paying job's skills query, this analyzes the the frequecy of skills
The main difference is that this does not limit the analysis to the top 10 highest paying relevant jobs.
```sql
SELECT
skills,
COUNT(skills_job_dim.job_id) AS skill_demand_count
FROM 
job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    (job_title_short = 'Data Analyst' OR job_title_short = 'Business Analyst')
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = 'False'
    AND job_country = 'United States'
GROUP BY
skills
ORDER BY 
skill_demand_count DESC
LIMIT 10;
```
              RESULTS
|    Skill   |     Skill Demand Count |
| ---------- | ---------------------- |
| SQL        | 2336                   |
| Excel      | 1721                   |
| Python     | 1295                   |
| Tableau    | 1288                   |
| SAS        | 834                    |
| Power BI   | 833                    |
| R          | 808                    |
| PowerPoint | 465                    |
| Word       | 456                    |
| SQL Server | 277                    |

SQL is by far the most requested skill — appearing in ~88% more roles than Python.

Excel remains highly dominant, showing it’s a fundamental tool across all levels of roles.

Python and Tableau are nearly tied, both being essential for data manipulation and visualization.

### 4. Top Paying Skills
This query answers what are the top skills based on average yearly salary.
By seperating the skills based on job average yearly salary we can see which skills are appropriate for each level.
This is useful to identify which skills are appropriate to learn if you are seeking a specific salary.
```sql
SELECT
skills,
ROUND (AVG(salary_year_avg),0) AS avg_salary
FROM 
job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    (job_title_short = 'Data Analyst' OR job_title_short = 'Business Analyst')
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = 'False'
    AND job_country = 'United States'
GROUP BY
skills
ORDER BY 
avg_salary DESC
LIMIT 25;
```
RESULTS
| Rank | Skill        | Avg Salary ($)  |
| ---- | ------------ | --------------- |
| 1    |   dplyr      |   196,250       |
| 2    | solidity     |   179,000       |
| 2    | rust         |   179,000       |
| 4    | hugging face |   175,000       |
| 5    | ansible      |   159,640       |

--Key Takeaways
Hybrid Skills Pay More: Analysts with ML, engineering, or blockchain skills command significantly higher salaries.
R (dplyr) remains a high-value tool in analytical roles, perhaps in finance, bioinformatics, or academic sectors.
Machine Learning tools like hugging face, pytorch, and tensorflow suggest analysts in AI-driven industries are better compensated.

### 5. Most Optimal Skills
This query answers which skills are most optimal to learn by looking at the combination of the overall frequency of skills with which are the highest paying.
```sql
WITH skills_demand AS (
SELECT
skills_dim.skill_id,
skills_dim.skills,
COUNT(skills_job_dim.job_id) AS demand_count
FROM 
job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    (job_title_short = 'Data Analyst' OR job_title_short = 'Business Analyst')
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = 'False'
    AND job_country = 'United States'
GROUP BY
skills_dim.skill_id
),
average_salary AS (
SELECT
skills_job_dim.skill_id,
ROUND (AVG(job_postings_fact.salary_year_avg),0) AS avg_salary
FROM 
job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    (job_title_short = 'Data Analyst' OR job_title_short = 'Business Analyst')
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = 'False'
    AND job_country = 'United States'
GROUP BY
skills_job_dim.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE 
    demand_count > 250
ORDER BY 
    avg_salary DESC, 
    demand_count DESC
LIMIT 25;
```
![Query5](Main SQL Files\Advanced SQL\Assets\Query5.png)

Insights:
SQL and Excel dominate in demand but offer lower-than-average salaries compared to programming-centric tools.
Python stands out as the highest-paying and highly demanded skill, ideal for maximizing career ROI.
Oracle and R offer strong salaries but have moderate demand.
Power BI, PowerPoint, and Word are in demand but correlate with lower salary brackets—often tied to reporting and presentation roles.
SAS and SQL Server are niche skills, moderately paid and less frequently required

## What I learned
During my time dedicated to this project, I have gained invaluable experience in data analytics!

-Advanced SQL Querying: Crafting complex query to gain insights. Specifically with CTE, GROUP BY and UNION functions.

-Data Aggregation: Manipulating data with aggregate functions such as COUNT() and AVG for insights.

-Problem Solving Skills: Increased development of my pre-existing problem solving skills. Using complex data to drive decision making.

## Conclusion

1. Top Paying Roles
The highest-paying roles for analysts are concentrated in major tech and finance hubs like San Mateo and Bethesda, with salaries reaching well over $300K. These positions are typically full-time, onsite, and offered by leading firms, emphasizing the premium placed on experienced analysts in high-impact industries.

2. Top Paying Skills
The top-paying jobs commonly require advanced technical skills such as Python, SQL, and Tableau, along with more specialized tools like SAS and Power BI. This indicates that proficiency in a blend of general-purpose and niche tools is a hallmark of high-paying analyst roles.

3. Most Demanded Skills
Skills like SQL (2336 postings) and Excel (1721 postings) dominate the market in terms of demand. Tools such as Python, Tableau, and Power BI follow closely, highlighting that a strong foundation in both data manipulation and visualization is expected for most roles. Notably, SQL appeared in nearly 90% more postings than Python, confirming its status as a non-negotiable skill.

4. Highest Paying Skills
Less common but technically advanced skills such as dplyr, Solidity, Rust, and Hugging Face correlated with the highest average salaries—ranging from $160K to nearly $200K. These results show that emerging technologies and cross-functional programming skills (e.g., ML or blockchain) can significantly boost earning potential for analysts in niche sectors.

5. Most Optimal Skills
When balancing both demand and average salary, Python emerges as the most strategic skill to learn. While SQL and Excel are more widely required, they are linked to lower salary tiers. In contrast, Python offers strong compensation and broad applicability, making it ideal for maximizing both marketability and income. Other skills like Oracle, R, and Tableau also performed well in this optimality measure.

## Closing Thoughts
This project was a valuable step in developing my data analytics skillset. Writing complex SQL queries and analyzing real job market data helped me understand how technical tools directly impact career opportunities. I gained deeper insight into which skills are most in-demand and which ones can lead to higher-paying roles. Most importantly, it reinforced my passion for turning data into actionable insights—and I’m excited to keep building on this foundation!

