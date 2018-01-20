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
INNER JOIN address ON staff.address_id = address.address_id;

-- 6b

SELECT * FROM payment;

SELECT staff.staff_id, staff.first_name,  staff.last_name, SUM(amount) AS 'Total Amount'
FROM staff
INNER JOIN payment ON staff.staff_id = payment.staff_id WHERE payment_date BETWEEN '2005-08-01' AND DATE '2005-08-31'
GROUP BY staff_id;

-- 6c
SELECT * FROM film_actor;
SELECT * FROM film;
SELECT film.film_id, film.title, film_actor.actor_id, COUNT(actor_id) AS 'Num of Actors'
FROM film
INNER JOIN film_actor
ON film.film_id = film_actor.film_id
GROUP BY title;


-- 6d
SELECT * FROM inventory;
SELECT * FROM film;
SELECT * FROM staff;
SELECT film.title, film.film_id, count(inventory.inventory_id) as copies FROM film
JOIN inventory
ON film.film_id = inventory.film_id
GROUP BY film.title
HAVING film.title = 'Hunchback Impossible';

-- 6e Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT customer.first_name, customer.last_name, customer.customer_id, sum(payment.amount) AS total_payment FROM customer
lEFT OUTER JOIN payment
ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY customer.last_name;



#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT title
FROM film
WHERE title LIKE 'k%' OR title LIKE 'q%'AND language_id IN
(
SELECT language_id
FROM language
WHERE name = 'English' 
);
 
#7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
  SELECT actor_id
  FROM film_actor
  WHERE film_id =
  (
   SELECT film_id
   FROM film
   WHERE title = 'Alone Trip'
  )
);

#7c. You want to run an email marketing campaign in Canada, for which your customer will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT customer.first_name, customer.last_name, customer.email, country.country
FROM customer
INNER JOIN address
ON customer.address_id = address.address_id
INNER JOIN city
ON address.city_id = city.city_id
INNER JOIN country
ON city.country_id = country.country_id
WHERE country.country = 'Canada'

#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT title
FROM film
WHERE film_id IN
(
  SELECT film_id
  FROM film_category
  WHERE category_id =
  (
   SELECT category_id
   FROM category
   WHERE name = 'family'
  )
);

#7e. Display the most frequently rented movies in descending order.
SELECT title, COUNT(title) as 'Frequently Rented Movies'
FROM film 
INNER JOIN inventory ON film.film_id = inventory.film_id
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.title
ORDER BY 'Frequently Rented Movies' DESC;



#7f. Write a query to display how much business, in dollars, each store brought in.
select city, country, sum(p.amount) as 'total_sales'
from payment p
join rental r on p.rental_id = r.rental_id
join inventory i on r.inventory_id = i.inventory_id
join store s on i.store_id = s.store_id
join address a on s.address_id = a.address_id
join city c on a.city_id = c.city_id
join country y on c.country_id = y.country_id
join staff f on s.manager_staff_id = f.staff_id
group by s.store_id
order by y.country, c.city;

#7g. Write a query to display for each store its store ID, city, and country.
select store_id, city, country
from store s, address a , city c, country y
where s.address_id = a.address_id
and a.city_id = c.city_id
and c.country_id = y.country_id;

#7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select name, sum(p.amount) as 'revenue'
from payment p
join rental r on p.rental_id = r.rental_id
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id
join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id
group by name
order by revenue
limit 5;

#8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
create view v_top_5_genre as 
select name, sum(p.amount) as 'revenue'
from payment p
join rental r on p.rental_id = r.rental_id
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id
join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id
group by name
order by revenue
limit 5;

#8b. How would you display the view that you created in 8a?
select * from v_top_5_genre;

#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view v_top_5_genre;

