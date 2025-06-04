--Question - What are the top paying business analyst and data analyst jobs?
--Specifically the top 10 roles that are on site and only includes those that do not contain a null yearly rate.

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
    AND job_location LIKE '%OH%'
ORDER BY
    salary_year_avg DESC
LIMIT 10;

