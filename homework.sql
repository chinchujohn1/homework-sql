use sakila;

SELECT * FROM actor;

SELECT first_name, last_name FROM actor;

--

SELECT CONCAT (first_name,' ' ,last_name) As Actor_Name FROM actor;

SELECT actor_id, first_name, last_name FROM actor WHERE first_name LIKE "Joe";

SELECT actor_id, first_name, last_name FROM actor WHERE last_name LIKE "%GEN%"; 

-- 2c

SELECT actor_id, first_name, last_name 
FROM actor WHERE last_name LIKE "%LI%" ORDER BY last_name, first_name; 

-- 2dcountry

SELECT country_id, country FROM country WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a
ALTER TABLE actor 
ADD COLUMN middle_name VARCHAR(100) NULL
AFTER first_name;

SELECT * FROM actor;

-- 3b

ALTER TABLE actor MODIFY COLUMN middle_name BLOB NULL;
-- 3c
ALTER TABLE actor DROP COLUMN middle_name;

SELECT * FROM actor;

-- 4a
SELECT last_name, COUNT(*) FROM actor GROUP BY last_name;
-- 4b
SELECT last_name,  COUNT(*) FROM actor GROUP BY last_name HAVING COUNT(*) >= 2;
-- 4c
UPDATE actor SET actor.first_name ='HARPO' WHERE actor.first_name = 'MUCHO GROUCHO' AND actor.last_name = 'WILLIAMS';

-- 4d
UPDATE actor
SET first_name = (
    CASE
        WHEN actor.first_name = "GROUCHO" THEN "MUCHO GROUCHO"
        WHEN actor.first_name = "HARPO" AND actor.actor_id = "172" THEN "GROUCHO"
        ELSE actor.first_name
    END)
WHERE actor.first_name = "GROUCHO" OR actor.first_name = "HARPO";
SELECT * FROM actor;

-- 5a
DESC sakila.address;

-- 6a
SELECT * FROM address;
SELECT * FROM staff;

SELECT staff.first_name,  staff.last_name, address.address
FROM staff
LEFT JOIN address ON staff.address_id = address.address_id;

-- 6b

SELECT * FROM payment;

SELECT staff.first_name,  staff.last_name, payment.amount
FROM staff
INNER JOIN payment ON staff.staff_id = payment.staff_id; -- WHERE date_time BETWEEN '2015-08-01 00:00:00' AND '2015-08-31 23:59:59';
-- BETWEEN'2005-08-01 08:51:04' AND '2005-08-25 08:51:04'
-- WHERE payment.staff_id = 1 AND payment.staff_id = 2;

-- 6c
SELECT * FROM film_actor;
SELECT * FROM film;



