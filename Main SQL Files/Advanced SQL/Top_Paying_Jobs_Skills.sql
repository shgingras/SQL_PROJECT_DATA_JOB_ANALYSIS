-- This query builds off of the previous query, finding the top top skills for the 10 highest paid data analyst and business analyst roles in the United States
-- Inlcuding insights and a breakdown of results for skills that had the highest frequency for the 10 most paying jobs.
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
--Observations
--Python is the most in-demand skill, appearing in 5 jobs across different companies.
--SQL and R are close behind, suggesting a strong demand for data querying and statistical analysis.
--Excel and Tableau remain strong staples for data analysis roles.
--Tools for workflow orchestration and big data (e.g., Airflow, Spark, Hadoop) are less common but associated with high-paying roles (e.g., Roblox).
--Niche tools like Looker, Snowflake, and BigQuery appear once but are indicative of modern data stacks.