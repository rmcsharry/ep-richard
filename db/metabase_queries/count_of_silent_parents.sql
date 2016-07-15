SELECT SUM(T3.parent) AS "# Silent Parents"
FROM
(
SELECT count(T1.id) as parent
FROM
	parents AS T1
LEFT JOIN
	pods AS T2
ON
	T1.pod_id = T2.id 
LEFT JOIN
	parent_visit_logs AS T3
ON
	T1.id = T3.parent_id
WHERE
	T2.id IS NOT NULL AND
	T2.is_test IS FALSE
GROUP BY T1.id
HAVING
	count(T3.parent_id) = 0
) AS T3

