--This query answers which skills are most optimal to learn.
--Looking at the combination of the overall frequency of skills with which are the highest paying.
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

--RESULTS
-- Skill	Demand	Salary	Trend
--Python	High	High	Ideal combo: high demand + high salary
--SQL	Very High	Medium-High	 Safe skill, widely required
--Excel	Very High	Medium	High demand but lower pay—seen as baseline skill
--Tableau	 High	High	Great for visual analysts
--PowerPoint Medium	Lower	Often required for presentations but less valuable on its own
