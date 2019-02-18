--Produce a count of the number of facilities that have a cost to guests of 10 or more.

SELECT COUNT(*)
FROM cd.facilities
WHERE guestcost >= 10;

--Produce a count of the number of recommendations each member has made. Order by member ID.

SELECT recommendedby, count(recommendedby)
FROM cd.members
WHERE recommendedby IS NOT null
GROUP BY recommendedby
ORDER BY recommendedby;

--Produce a list of the total number of slots booked per facility. 
--For now, just produce an output table consisting of facility id and slots, sorted by facility id.

SELECT facid, SUM(slots)
FROM cd.bookings
GROUP BY facid
ORDER BY facid;

--Find the total number of members who have made at least one booking.
SELECT COUNT (DISTINCT(memid)) 
FROM cd.bookings
WHERE slots IS NOT null;

--Produce a list of the total number of slots booked per facility in the month of September 2012. 
--Produce an output table consisting of facility id and slots, sorted by the number of slots.

SELECT facid, SUM(slots) as "Total Slots"
FROM cd.bookings
WHERE starttime >= '2012-09-01' AND starttime < '2012-10-01'
GROUP BY facid
ORDER BY "Total Slots";

--Produce a list of the total number of slots booked per facility per month in the year of 2012. 
--Produce an output table consisting of facility id and slots, sorted by the id and month.

SELECT facid, extract(month from starttime) as month, SUM(slots) as "total slots"
FROM cd.bookings
WHERE starttime >= '2012-01-01' AND starttime <'2013-01-01'
GROUP BY facid, month
ORDER BY facid, month;

--Produce a list of facilities with more than 1000 slots booked. 
--Produce an output table consisting of facility id and slots, sorted by facility id.
SELECT facid,  SUM(slots) as "Total Slots"
FROM cd.bookings
GROUP BY facid
HAVING SUM(slots) >1000
ORDER BY facid;

--Produce a list of facilities along with their total revenue. The output table should consist of facility name and revenue, sorted by revenue. 
--Remember that there's a different cost for guests and members!

SELECT a.name, SUM( b.slots * CASE WHEN b.memid = 0 THEN a.guestcost
				   ELSE a.membercost END) as revenue
FROM cd.facilities a
INNER JOIN cd.bookings b ON a.facid=b.facid
GROUP BY a.name
ORDER BY revenue;

--Produce a list of facilities with a total revenue less than 1000. Produce an output table consisting of facility name and revenue, sorted by revenue. 
--Remember that there's a different cost for guests and members!

SELECT a.name, SUM( b.slots * CASE WHEN b.memid = 0 THEN a.guestcost
				   ELSE a.membercost END) as revenue
FROM cd.facilities a
INNER JOIN cd.bookings b ON a.facid=b.facid
GROUP BY a.name
HAVING SUM( b.slots * CASE WHEN b.memid = 0 THEN a.guestcost
				   ELSE a.membercost END) <1000
ORDER BY revenue;

--Produce a list of the total number of hours booked per facility, remembering that a slot lasts half an hour. 
--The output table should consist of the facility id, name, and hours booked, sorted by facility id. 
--Try formatting the hours to two decimal places.

SELECT a.facid, b.name, ROUND (SUM(a.slots*0.5),2) as "Total Hours"
FROM cd.bookings as a
JOIN cd.facilities as b ON a.facid=b.facid
GROUP BY  a.facid, b.name
ORDER BY a.facid;

--Produce a list of each member name, id, and their first booking after September 1st 2012. Order by member ID.
SELECT a.surname, a.firstname, a.memid, MIN(b.starttime)
FROM cd.bookings b
JOIN cd.members a ON a.memid=b.memid
WHERE b.starttime >= '2012-09-01' 
GROUP BY a.surname, a.firstname, a.memid
ORDER BY a.memid;

****NEED ADDITIONAL PRACTICE****

--Output the facility id that has the highest number of slots booked. 
--For bonus points, try a version without a LIMIT clause. This version will probably look messy!

-- *CTEs are declared in the form WITH CTEName as (SQL-Expression). You can see our query redefined to use a CTE below:
 --You can see that we've factored out our repeated selections from cd.bookings into a single CTE, and made the query a lot simpler to read in the process!**
    
with sum as (select facid, sum(slots) as totalslots
	from cd.bookings
	group by facid
)
select facid, totalslots 
	from sum
	where totalslots = (select max(totalslots) from sum);
 
--Output the facility id that has the highest number of slots booked. For bonus points, try a version without a LIMIT clause. This version will probably look messy!
--Produce a list of the total number of slots booked per facility per month in the year of 2012. 
--In this version, include output rows containing totals for all months per facility, and a total for all months for all facilities. 
--The output table should consist of facility id, month and slots, sorted by the id and month. 
--When calculating the aggregated values for all months and all facids, return null values in the month and facid columns.

SELECT facid, extract(month from starttime) as month, SUM(slots) as "slots"
FROM cd.bookings
WHERE starttime >= '2012-01-01' AND starttime <'2013-01-01'
GROUP BY rollup(facid, month)
ORDER BY facid, month;

--Produce a list of the total number of slots booked per facility per month in the year of 2012. In this version, include output rows containing totals for all months per facility, and a total for all months for all facilities. The output table should consist of facility id, month and slots, sorted by the id and month. When calculating the aggregated values for all months and all facids, return null values in the month and facid columns.--
select facid, extract(month from starttime) as month, sum(slots) as slots
	from cd.bookings
	where
		starttime >= '2012-01-01'
		and starttime < '2013-01-01'
	group by rollup(facid, month)
order by facid, month;  

--(ROLLUP produces a hierarchy of aggregations in the order passed into it: for example, ROLLUP(facid, month) outputs aggregations on (facid, month), (facid), and (). If we wanted an aggregation of all facilities for a month (instead of all months for a facility) we'd have to reverse the order, using ROLLUP(month, facid). Alternatively, if we instead want all possible permutations of the columns we pass in, we can use CUBE rather than ROLLUP. This will produce (facid, month), (month), (facid), and ().
ROLLUP and CUBE are special cases of GROUPING SETS. GROUPING SETS allow you to specify the exact aggregation permutations you want: you could, for example, ask for just (facid, month) and (facid), skipping the top-level aggregation.)--

--Produce a monotonically increasing numbered list of members, ordered by their date of joining. Remember that member IDs are not guaranteed to be sequential.--

select row_number() over(order by joindate), firstname, surname
	from cd.members
order by joindate 
