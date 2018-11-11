-- Instruct SQL to use sakila data base --

USE sakila;

-- 1a. Display the first and last names of all actors from the table actor.
SELECT 
    first_name, last_name
FROM
    actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.

SELECT 
    UPPER(CONCAT(first_name, ' , ', last_name)) AS 'Actor Name'
FROM
    actor;
-- 2a. You need to find the ID number, first name, and last name of an actor, 
-- of whom you know only the first name, "Joe." What is one query would you use
--  to obtain this information?

SELECT 
    actor_id, first_name, last_name
FROM
    actor
WHERE
    first_name = 'Joe';

-- 2b. Find all actors whose last name contain the letters GEN:

SELECT 
    *
FROM
    actor
WHERE
    last_name LIKE '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:

SELECT 
    *
FROM
    actor
WHERE
    last_name LIKE '%LI%'
ORDER BY last_name , first_name;
-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:

SELECT 
    country_id, country
FROM
    country
WHERE
    country IN ('Afghanistan' , 'Bangladesh', 'China');
-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create 
-- a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference 
-- between it and VARCHAR are significant).

ALTER TABLE actor
	ADD description BLOB;

SELECT 
    *
FROM
    actor;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much
-- effort. Delete the description column.

ALTER TABLE actor
	DROP COLUMN description;
    
SELECT 
    *
FROM
    actor;

-- 4a. List the last names of actors, as well as how many actors have that last name.

SELECT 
    last_name, COUNT(last_name) AS 'Count of Last Name'
FROM
    actor
GROUP BY last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

SELECT 
    last_name, COUNT(last_name) AS 'Count of Last Name'
FROM
    actor
GROUP BY last_name
HAVING COUNT(last_name) >= 2;



-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.

SELECT 
    *
FROM
    actor
WHERE
    first_name = 'GROUCHO'
        AND last_name = 'WILLIAMS';

-- next update table to make correction -- 

UPDATE actor 
SET 
    first_name = 'HARPO'
WHERE
    actor_id = 172;

-- Verify Results -- 

SELECT 
    *
FROM
    actor
WHERE
    actor_id = 172;

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the 
-- first name of the actor is currently HARPO, change it to GROUCHO.

SELECT 
    *
FROM
    actor
WHERE
    first_name = 'HARPO';

-- Now perform single query update --

UPDATE actor 
SET 
    first_name = 'GROUCHO'
WHERE
    actor_id = 172;

-- verify results -- 

SELECT 
    *
FROM
    actor
WHERE
    actor_id = 172; 

-- 5a. You cannot locate the schema of the address table. 
-- Which query would you use to re-create it?

SHOW CREATE TABLE address;

-- 6a. Use JOIN to display the first and last names, as well
-- as the address, of each staff member. Use the tables staff and address:

SELECT 
    staff.first_name, staff.last_name, address.address
FROM
    staff
        LEFT JOIN
    address USING (address_id);

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. 
-- Use tables staff and payment.

SELECT 
    staff.staff_id,
    staff.first_name,
    staff.last_name,
    SUM(payment.amount) AS 'Sum of Payment'
   --  payment.payment_date
FROM
    staff
        JOIN
    payment USING (staff_id)
WHERE
    payment_date BETWEEN '2005-08-01 00:00:00' AND '2005-08-31 00:00:00'
    
GROUP BY staff_id;

-- 6c. List each film and the number of actors who are listed for that film.
--  Use tables film_actor and film. Use inner join.

SELECT 	film.title,
		COUNT(film_actor.actor_id) AS '# of actors listed '

FROM film

JOIN film_actor USING (film_id)

GROUP BY title; 
		
        
		
-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT 
		f.title,
		COUNT(i.film_id) AS 'Copies available'

FROM inventory i

JOIN film f USING(film_id)

WHERE f.title = 'Hunchback Impossible';



-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
-- List the customers alphabetically by last name:

SELECT 	c.customer_id,
		c.first_name,
        c.last_name,
		SUM(p.amount) AS 'Total Payment Amount'
        
FROM customer c

JOIN payment p USING(customer_id)

GROUP BY customer_id

ORDER BY last_name ASC;

-- 7a. 
--  Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.

-- FIRST determine id used for english

SELECT f.title

FROM film f

WHERE language_id IN (

		SELECT language_id
        
        FROM language 
        
		WHERE name = 'ENGLISH'

					)
AND f.title LIKE 'K%'

OR f.title LIKE   'Q%' ; 



-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT 	a.actor_id,
		CONCAT(first_name, " ", last_name) AS 'Actors in film Alone Trip'
		

FROM actor a

WHERE actor_id IN(

	SELECT actor_id
    FROM film_actor fa 
    WHERE film_id IN (
    
		SELECT film_id
        FROM film f
        WHERE title = 'Alone Trip'
    )


);


-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names 
-- and email addresses of all Canadian customers. Use joins to retrieve this information.


/* EMAIL - customer table
	
    email
    |
    Customer table
	| 
	address_id
	|
	Address table
	|
	city_id
	|
	City table
	|
	country_id
	|
country = 'canada' on Country table


*/

SELECT c.email AS 'Canadian Customer Emails'

FROM customer

JOIN address USING (address_id)



-- 7d. Sales have been lagging among young families, and you wish to target all
--  family movies for a promotion. Identify all movies categorized as family films.

-- 7e. Display the most frequently rented movies in descending order.

-- 7f. Write a query to display how much business, in dollars, each store brought in.

-- 7g. Write a query to display for each store its store ID, city, and country.

-- 7h. List the top five genres in gross revenue in descending order. 
-- (Hint: you may need to use the following tables: category, film_category, inventory,
--  payment, and rental.)


-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

-- 8b. How would you display the view that you created in 8a?

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.




