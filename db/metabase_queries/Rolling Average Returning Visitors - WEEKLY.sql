--
-- Author: Richard McSharry
-- Date: 06 Jul 2016
--
--
-- *** DESCRIPTION ***
-- This query calculates a 90 day moving average percentage, based on the % of parents who visited 2 weeks in a row. 
--
-- *** NOTES ***
-- A. It will NOT work across years and only gets data from the 1st Jan of the current year.
-- B. You can change the 'seconds' value in Step 7 to get different length moving averages (30-day, 60-day, 90-day etc)
-- C. See the same query but for daily moving average for explanation of each step

SELECT
	 T2.week_of_year AS "Week Of Year"
	,to_char(T2.returnweek_date, 'DD-Mon') AS "Week Start Date"
	,T2.visited_last_week AS "# Visited prev. week"
	,T2.returners AS "# Returned"
	,round(T2.percent_returned)::NUMERIC AS "% Returned"
	-- Step 9
        ,round(avg(T2.percent_returned) OVER (PARTITION BY group_number ORDER BY T2.returnweek_date))::NUMERIC AS "% Rolling Average"
FROM
(SELECT
	 T1.week_of_year
	,T1.returnweek_date
	,T1.visited_last_week
	,T1.returners
	,T1.percent_returned
	,T1.interval_group
	-- Step 8
	,T1.week_of_year - row_number() OVER (PARTITION BY interval_group ORDER BY T1.week_of_year) AS group_number
FROM
	(SELECT
		-- Step 7
		-- Return the basic form of the data we want, with the % calculation
		-- and use an epoch calculation to generate a grouping interval so we can group the data to do the moving average
		-- (eg.for an x-day moving average 259200 secs = 30 days, 7776000 secs = 90 days
		 visited.week_of_year
		,visited.returnweek_date
		,visited.visited_last_week
		,COALESCE(returned.returners,0) AS returners
		,COALESCE(round(returned.returners::NUMERIC / visited.visited_last_week * 100.0, 1), 0.0) AS percent_returned
		,'epoch'::timestamp + '7776000 seconds'::interval * (extract(epoch from visited.returnweek_date)::int4 / 7776000) as interval_group
	FROM 
		-- Step 4
		(SELECT 
		 date_series.visitweek_date AS "returnweek_date"
		,EXTRACT(week FROM date_series.visitweek_date) AS "week_of_year"
		,COALESCE(weekly_visit_count.visitors, 0) AS "visited_last_week"

		FROM
			-- Step 1
			-- generate weeks of the year from today back to the start of the current year (ISO standard specifies 4th Jan as start of 1st week)
			(SELECT 
			 generate_series(date_trunc('week', (extract('year' from now())::text || '-1-4')::date), now() - INTERVAL '1 week', '1 week'::INTERVAL) AS "visitweek_date"
			) AS date_series
			
			LEFT JOIN
			-- Step 2
			(SELECT
				 count(DISTINCT(PVL.parent_id)) AS "visitors"
				,date_trunc('week', PVL.created_at) + INTERVAL '1 week' AS "nextweek_date"
			FROM
				parent_visit_logs AS PVL
			INNER JOIN
			-- Step 3
				pods
			ON
				PVL.pod_id = pods.id AND
				pods.is_test = FALSE
			WHERE
				PVL.created_at > now() - INTERVAL '12 months' AND
				extract(DOY FROM PVL.created_at) <= extract(DOY FROM now())
			GROUP BY
				 nextweek_date
			) AS weekly_visit_count
			ON
			date_series.visitweek_date = weekly_visit_count.nextweek_date
	) AS visited
	
	LEFT JOIN
	-- Step 5

	(SELECT
		 count(A.parent_id) AS "returners"
		,A.week_start
		,A.week_no
	FROM
	-- Step 6
		(SELECT
			 DISTINCT(parent_id)
			 ,pod_id
			,DATE_TRUNC('week', created_at) AS "week_start"
			,EXTRACT(week FROM created_at) AS "week_no"
		FROM
			parent_visit_logs
		WHERE
			created_at > now() - INTERVAL '12 months'
		) AS A
		
		INNER JOIN
		
		(SELECT
			 DISTINCT(parent_id)
			,DATE_TRUNC('week', created_at) AS "week_start"
			,EXTRACT(week FROM created_at) AS "week_no"
		FROM
			parent_visit_logs
		WHERE
			created_at > now() - INTERVAL '12 months'
		) AS B
		ON 
		A.parent_id = B.parent_id AND
		A.week_no = B.week_no + 1
		
		INNER JOIN pods
		ON
		A.pod_id = pods.id AND
		pods.is_test = FALSE
		
		GROUP BY
		A.week_no, A.week_start
	) AS returned
	ON
	visited.week_of_year = returned.week_no
) AS T1
) AS T2
ORDER BY T2.returnweek_date DESC
LIMIT 12 -- comment this line to see full year