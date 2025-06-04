--Similar to the top paying job's skills query, this analyzes the the frequecy of skills
--The main difference is that this does not limit the analysis to the top 10 highest paying relevant jobs.
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

-- RESULTS
--| **Skill**  | **Skill Demand Count** |
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


