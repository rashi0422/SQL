-- No of rows in the dataset 
select count(*) from population;
select count(*) from literacy;

-- Insights for Jharkhand and Bihar 

SELECT * FROM literacy
WHERE state IN ('Jharkhand','Bihar');

-- All the state names starting with 'A' 

SELECT DISTINCT state FROM literacy
where state LIKE 'a%';

-- Total population of India 

SELECT SUM(population) AS total_population 
FROM population;

-- Average growth of India in the year 2011

SELECT ROUND(AVG(growth)*100, 2) AS Average_Growth 
FROM literacy; 

-- Average growth percentage for each state

SELECT state, ROUND(AVG(growth)*100, 2) AS Average_Growth 
FROM literacy
GROUP BY state;

-- Average Sex Ratio for each state 

SELECT state, ROUND(AVG(sex_ratio),2) AS Average_SexRatio 
FROM literacy 
GROUP BY state
ORDER BY state;

-- Average literacy rate for each state 

SELECT state, ROUND(AVG(literacy),2) AS Average_LiteracyRate 
FROM literacy 
GROUP BY state
ORDER BY Average_LiteracyRate DESC ;

-- Top 5 states displaying highest growth percentage ratio 

SELECT state, ROUND(AVG(growth)*100, 2) AS Average_Growth 
FROM literacy 
GROUP BY state
ORDER BY Average_Growth DESC
LIMIT 5;

-- 5 states showing Least Sex Ratio

SELECT state, ROUND(AVG(sex_ratio),2) AS Average_SexRatio 
FROM literacy 
GROUP BY state
ORDER BY Average_SexRatio
LIMIT 5;

-- fetch Top and Bottom 3 states for literacy rate in a single result set 

SELECT * FROM (SELECT state, ROUND(AVG(literacy),2) AS Average_LiteracyRate 
FROM literacy 
GROUP BY state
ORDER BY Average_LiteracyRate DESC 
LIMIT 3 ) A 
UNION 
SELECT * FROM (
SELECT state, ROUND(AVG(literacy),2) AS Average_LiteracyRate 
FROM literacy 
GROUP BY state
ORDER BY Average_LiteracyRate ASC
LIMIT 3 ) B ;

-- total number of males and females from the census data 

SELECT c.district, c.state , ROUND(c.population/(c.sex_ratio + 1), 0) AS males, ROUND((c.population*c.sex_ratio)/(c.sex_ratio+1),0) AS females 
FROM(
SELECT l.district, l.state, l.sex_ratio/1000 as sex_ratio, p.population 
FROM literacy l
INNER JOIN population p 
ON l.district = p.district ) c ;

-- Total no of people who are literate from the population in each state 

SELECT d.state, SUM(d.Literate_people) AS total_literates FROM
(select c.district, c.state, ROUND(c.literacy_ratio*c.population,0) as Literate_people FROM
(SELECT l.district, l.state, l.literacy/100 as literacy_ratio, p.population 
FROM literacy l
INNER JOIN population p 
ON l.district = p.district) c ) d
GROUP BY state;


-- Find out the top 3 district from each states having high literacy ratio

SELECT a.* FROM
(SELECT state, district, Literacy, 
DENSE_RANK() OVER(partition by state order by literacy desc) as rnk
FROM literacy ) a
WHERE a.rnk <= 3;