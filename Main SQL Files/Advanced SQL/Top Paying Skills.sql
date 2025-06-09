--This query answers what are the top skills based on the associated average yearly salary.
--By seperating the skills based on job average yearly salary we can see which skills are appropriate for each level.
--This is useful to identify which skills are appropriate to learn if you are seeking a specific salary level.
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
--| Rank | Skill        | Avg Salary (\$) |
| ---- | ------------ | --------------- |
| 1    | **dplyr**    | **196,250**     |
| 2    | solidity     | 179,000         |
| 2    | rust         | 179,000         |
| 4    | hugging face | 175,000         |
| 5    | ansible      | 159,640         |

--Key Takeaways
--Hybrid Skills Pay More: Analysts with ML, engineering, or blockchain skills command significantly higher salaries.

--R (dplyr) remains a high-value tool in analytical roles, perhaps in finance, bioinformatics, or academic sectors.

--Machine Learning tools like hugging face, pytorch, and tensorflow suggest analysts in AI-driven industries are better compensated.



