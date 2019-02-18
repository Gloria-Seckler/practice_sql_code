# practice_sql_code

--How can you retrieve all the information from the cd.facilities table?
SELECT *
FROM cd.facilities;

--You want to print out a list of all of the facilities and their cost to members. 
--How would you retrieve a list of only facility names and costs?
SELECT name, membercost
FROM cd.facilities;

--How can you produce a list of facilities that charge a fee to members?
SELECT name, membercost
FROM cd.facilities
WHERE membercost >0;

--!!!!! How can you produce a list of facilities that charge a fee to members, 
--and that fee is less than 1/50th of the monthly maintenance cost? 
--Return the facid, facility name, member cost, and monthly maintenance of the facilities in question.
SELECT facid, name, membercost, monthlymaintenance
FROM cd.facilities
WHERE membercost >0 AND (membercost < monthlymaintenance/50.0);

--How can you produce a list of all facilities with the word 'Tennis' in their name?
SELECT *
FROM cd.facilities
WHERE name LIKE '%Tennis%';

--How can you retrieve the details of facilities with ID 1 and 5? Try to do it without using the OR operator.
SELECT *
FROM cd.facilities
WHERE facid IN (1,5);

--How can you produce a list of members who joined after the start of September 2012? 
--Return the memid, surname, firstname, and joindate of the members in question.
SELECT memid, surname, firstname, joindate
FROM cd.members
WHERE joindate > '2012-09-01';

--How can you produce an ordered list of the first 10 surnames in the members table? 
--The list must not contain duplicates.
SELECT DISTINCT surname
FROM cd.members
ORDER BY surname
LIMIT 10;

--You'd like to get the signup date of your last member. How can you retrieve this information?
SELECT joindate
FROM cd.members
ORDER BY joindate DESC
LIMIT 1;

select max(joindate) as latest from cd.members;

--Produce a count of the number of facilities that have a cost to guests of 10 or more.
SELECT count(*)
FROM cd.facilities
WHERE guestcost >=10;

--Produce a list of the total number of slots booked per facility in the month of September 2012. 
--Produce an output table consisting of facility id and slots, sorted by the number of slots.
SELECT facid, count(slots)
FROM cd.bookings
WHERE starttime BETWEEN '2012-09-01' and '2012-09-30'
GROUP BY facid
ORDER BY count(slots);

select facid, sum(slots) as "Total Slots" from cd.bookings where starttime >= '2012-09-01' and starttime < '2012-10-01' group by facid order by sum(slots);

--Produce a list of facilities with more than 1000 slots booked. 
--Produce an output table consisting of facility id and total slots, sorted by facility id.
SELECT facid, count(slots)
FROM cd.bookings
GROUP BY facid
HAVING count(slots)>1000
ORDER BY facid;

select facid, sum(slots) as "Total Slots" from cd.bookings group by facid having sum(slots) > 1000 order by facid;

--How can you produce a list of the start times for bookings for tennis courts, for the date '2012-09-21'? 
--Return a list of start time and facility name pairings, ordered by the time.
SELECT a.name, b.starttime
FROM cd.facilities as a
JOIN cd.bookings as b ON a.facid=b.facid
WHERE a.name LIKE '%Tennis Court%' and b.starttime ='2012-09-21'
ORDER BY b.starttime;

--How can you produce a list of the start times for bookings by members named 'David Farrell'?
SELECT a.firstname, a.surname, b.starttime
FROM cd.members as a
JOIN cd.bookings as b ON a.memid=b.memid
WHERE a.firstname LIKE 'David' AND a.surname LIKE 'Farrell'
ORDER BY b.starttime;

