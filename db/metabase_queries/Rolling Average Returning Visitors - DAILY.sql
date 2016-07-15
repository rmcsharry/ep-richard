--
-- Author: Richard McSharry
-- Date: 06 Jul 2016
--
--
-- *** DESCRIPTION ***
-- This query calculates a 90 day moving average percentage, based on the % of parents who visited 2 days in a row. 
--
-- *** NOTES ***
-- A. It will NOT work across years and only gets data from the 1st Jan of the current year.
-- B. You can change the 'seconds' value in Step 7 to get different length moving averages (30-day, 60-day, 90-day etc)
--
-- For a simplified example, see this:
-- http://stackoverflow.com/questions/13818524/moving-average-based-on-timestamps-in-postgresql
--
--
-- *** METHOD ***
-- The query is described in how it is built up from various sub-queries, starting with the base set of data. Note that we
-- must return each day of the year with a count of the number of parents that visited YESTERDAY and RETURNED TODAY. The latter 
-- is then calculated as a % of the former and finally these % values are used to calculate the moving average.
--
-- Step 1
-- Since there are days when no parents visit, we must first generate a series representing each day of the year
--
-- Step 2
-- Count the number of visitors (the denominator) on each day and return the date of the following day so we can join that to
-- the query that counts those who visit the next day
--
-- Step 3
-- We don't want to include visits to test pods, so these are removed at this point
--
-- Step 4
-- At this point we have 3 values:
-- 1 an integer representing the day of the year that we counted the number of visitors for
-- 2 the calendar date we are going to use to calculate who returned the following day
-- 3 the actual count of the number of vistors (with nulls converted to 0)
--
-- Step 5
-- We now do a sub-query that gets the parent ids who visited on day X and see if they returned on day X+1 and count the returners
-- (again, we must ignore test pods)
--
-- Step 6
-- This is the core of the work, a two part sub-query that matches distinct parent_ids from Day X to parent_ids on Day X+1
-- and thus allows the 'returers' count in Step 5 above to be done
--
-- Step 7
-- Calculates the raw % value of visitors/returners and creates a grouping number based on the X-day moving average we want
-- The grouping basically provides the same identifer to all the data for a group (eg. 30 day group, 90 day group)
--
-- Step 8
-- Returns the same values as step 7 but uses the day of the year and the grouping interval to partition the data
--
-- Step 9
-- Finally we can calculate the average for each day, by partitioning over the group_number generated in step 8

SELECT
	 T2.day_of_year AS "Day Of Year"
	,to_char(T2.return_date, 'DD-Mon') AS "Date"
	,T2.visited_yesterday AS "# Visited prev. day"
	,T2.returners AS "# Returned"
	,round(T2.percent_returned)::NUMERIC AS "% Returned"
	-- Step 9
        ,round(avg(T2.percent_returned) OVER (PARTITION BY group_number ORDER BY T2.return_date))::NUMERIC AS "% Rolling Average"
FROM
(SELECT
	 T1.day_of_year
	,T1.return_date
	,T1.visited_yesterday
	,T1.returners
	,T1.percent_returned
	,T1.interval_group
	-- Step 8
	,T1.day_of_year - row_number() OVER (PARTITION BY interval_group ORDER BY T1.day_of_year) AS group_number
FROM
	(SELECT
		-- Step 7
		-- Return the basic form of the data we want, with the % calculation
		-- and use an epoch calculation to generate a grouping interval so we can group the data to do the moving average
		-- (eg.for an x-day moving average 259200 secs = 30 days, 7776000 secs = 90 days
		 visited.day_of_year
		,visited.return_date
		,visited.visited_yesterday
		,COALESCE(returned.returners,0) AS returners
		,COALESCE(round(returned.returners::NUMERIC / visited.visited_yesterday * 100.0, 1), 0.0) AS percent_returned
		,'epoch'::timestamp + '7776000 seconds'::interval * (extract(epoch from visited.return_date)::int4 / 7776000) as interval_group
	FROM 
		-- Step 4
		-- Now we have date of the next day, an integer for the day of the year (current day) 
		-- and the count of the visitors for the current day
		(SELECT 
		 date_series.visitday_date AS "return_date"
		,EXTRACT(doy FROM date_series.visitday_date) AS "day_of_year"
		,COALESCE(daily_visit_count.visitors, 0) AS "visited_yesterday"

		FROM
			-- Step 1
			-- generate days of the year from today back to the start of the current year
			(SELECT 
			 generate_series(date_trunc('year', now()), now() - INTERVAL '1 day', '1 day'::INTERVAL) AS "visitday_date"
			) AS date_series
			
			LEFT JOIN
			-- Step 2
			-- count of visits per day BUT SHIFT the date value to the next day (to use later)
			(SELECT
				 count(DISTINCT(PVL.parent_id)) AS "visitors"
				,date_trunc('day', PVL.created_at) + INTERVAL '1 day' AS "nextday_date"
			FROM
				parent_visit_logs AS PVL
			INNER JOIN
			-- Step 3
			-- Join to Pods to remove test pods, since we don't want to count visits to those
				pods
			ON
				PVL.pod_id = pods.id AND
				pods.is_test = FALSE
			WHERE
				PVL.created_at > now() - INTERVAL '12 months'
			GROUP BY
				 nextday_date
			) AS daily_visit_count
			ON
			date_series.visitday_date = daily_visit_count.nextday_date
	) AS visited
	
	LEFT JOIN
	-- Step 5
	-- So now left join ALL the days of the year (so we don't have any days missing) to the count of 'returners'
	-- so that the visitor acount in the query above is matched to the same day as the returner count in the query below

	(SELECT
		 count(A.parent_id) AS "returners"
		,A.visit_date
		,A.day_of_year
	FROM
	-- Step 6
	-- This inner join query is matching the parent_id on Day X to the parent_id on Day X+1
	-- Note we use DISTINCT since we don't care about multiple visits by the same parent
		(SELECT
			 DISTINCT(parent_id)
			,pod_id
			,DATE_TRUNC('day', created_at) AS "visit_date"
			,EXTRACT(doy FROM created_at) AS "day_of_year"
		FROM
			parent_visit_logs
		WHERE
			created_at > now() - INTERVAL '12 months'
		) AS A
		
		INNER JOIN
		
		(SELECT
			 DISTINCT(parent_id)
			,DATE_TRUNC('day', created_at) AS "visit_date"
			,EXTRACT(doy FROM created_at) AS "day_of_year"
		FROM
			parent_visit_logs
		WHERE
			created_at > now() - INTERVAL '12 months'
		) AS B
		ON
		A.parent_id = B.parent_id AND
		A.day_of_year = B.day_of_year + 1

		INNER JOIN pods
		ON
		A.pod_id = pods.id AND
		pods.is_test = FALSE
		
		GROUP BY
		A.day_of_year, A.visit_date
	) AS returned
	ON
	visited.day_of_year = returned.day_of_year
) AS T1
) AS T2
ORDER BY T2.day_of_year DESC
LIMIT 14 -- comment this line to see full year