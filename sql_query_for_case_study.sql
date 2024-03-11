-- 1: Formatting the Data
/* 1. a.
UPDATE flights SET price = CAST(REPLACE(price, ',', '') AS UNSIGNED);
*/
/* 1. b. I.
UPDATE flights SET dep_time = str_to_date(concat(date,' ', dep_time), '%d-%m-%Y %H:%i');
*/
/* 1. b. II.
ALTER TABLE flights ADD COLUMN `time_taken(in mins)` INTEGER AFTER time_taken
UPDATE flights
    SET `time_taken(in mins)` =
        CAST(REPLACE(TRIM(SUBSTRING_INDEX(trim(time_taken), ' ', 1)), 'h', '') AS signed) * 60 +
        CAST(REPLACE(TRIM(SUBSTRING_INDEX(trim(time_taken), ' ', -1)), 'm', '') AS signed);
*/
/* 1. b. III.
UPDATE flights SET arr_time = DATE_ADD(dep_time, INTERVAL `time_taken(in mins)` minute)
*/

-- 2: SQL Queries for Insights
/*	
Q1. What are the minimum and maximum prices, as well as the corresponding travel times, for flights connecting different cities in the Indian airline dataset?

SELECT `from`, `to`, MIN(price) AS 'minimum_price', 
MAX(price) AS 'maximum_price', 
DATE_FORMAT(MIN(TIMEDIFF(arr_time, dep_time)), '%Hh %im') AS 'minimum_time', 
DATE_FORMAT(MAX(TIMEDIFF(arr_time, dep_time)), '%Hh %im') AS 'maximum_time'
FROM indian_airline.flights GROUP BY `from`, `to`;
*/
/* 
Q2. What are the airlines operating in the Indian airline dataset, and what is the range of prices and travel times associated with their flights?

SELECT airline, MIN(price) AS 'minimum_price', ROUND(AVG(price)) AS 'average_price',
MAX(price) AS 'maximum_price',
DATE_FORMAT(MIN(TIMEDIFF(arr_time, dep_time)), '%Hh %im') AS 'minimum_time', 
DATE_FORMAT(MAX(TIMEDIFF(arr_time, dep_time)), '%Hh %im') AS 'maximum_time'
FROM indian_airline.flights GROUP BY airline;
*/
/* 
Q3. What are the details of the flights with the minimum price for each airline operating from 'Delhi' to 'Bangalore'?

WITH RankedFlights AS (
	SELECT airline, dep_time, `from`, time_taken, stop, arr_time, `to`, price,
	ROW_NUMBER() OVER (PARTITION BY airline ORDER BY price) AS row_num
    FROM flights WHERE `from` = 'Delhi' AND `to` = 'Bangalore'
)
SELECT airline, dep_time, `from`, time_taken, stop, arr_time, `to`, price
FROM RankedFlights WHERE row_num = 1;
*/
/*
Q4. What are the details of the flights with the maximum price for each airline operating from 'Delhi' to 'Bangalore'?

WITH RankedFlights AS (
	SELECT airline, dep_time, `from`, time_taken, stop, arr_time, `to`, price,
	ROW_NUMBER() OVER (PARTITION BY airline ORDER BY price desc) AS row_num
    FROM flights WHERE `from` = 'Delhi' AND `to` = 'Bangalore'
)
SELECT airline, dep_time, `from`, time_taken, stop, arr_time, `to`, price
FROM RankedFlights WHERE row_num = 1;
*/
/*
Q5. Which Airline Has the Highest Number of Flights?

SELECT airline, count(*) as 'num_flights' 
FROM indian_airline.flights GROUP BY airline ORDER BY num_flights DESC;
*/
/*
Q6. What is the distribution of flight departures for each day of the week, categorized into different time ranges (6–12, 12–18, 18–24, 0–6)? 
Additionally, could you provide the overall total counts for each time range across all days?

SELECT 
    dayname(dep_time) AS 'day',
    SUM(CASE WHEN TIME(dep_time) >= '06:00:00' AND TIME(dep_time) < '12:00:00' THEN 1 ELSE 0 END) AS '6-12',
    SUM(CASE WHEN TIME(dep_time) >= '12:00:00' AND TIME(dep_time) < '18:00:00' THEN 1 ELSE 0 END) AS '12-18',
    SUM(CASE WHEN TIME(dep_time) >= '18:00:00' AND TIME(dep_time) < '23:59:00' THEN 1 ELSE 0 END) AS '18-24',
    SUM(CASE WHEN TIME(dep_time) >= '00:00:00' AND TIME(dep_time) < '06:00:00' THEN 1 ELSE 0 END) AS '0-6'
FROM indian_airline.flights GROUP BY dayname(dep_time) WITH ROLLUP ;
*/
/*
Q7. Compare the Average Difference of Time for "Non-stop", "1-stop", "2-stop" Flights:

SELECT stop, DATE_FORMAT(SEC_TO_TIME(avg(`time_taken(in mins)`*60)), '%Hh %im') AS 'avg_time' 
FROM indian_airline.flights GROUP BY stop;
*/










 


