USE mavenmovies; -- This is for selecting the mavenmovies database

/* 
Q1. My partner and I want to come by each of the stores in person and meet the managers. 
Please send over the managers’ names at each store, with the full address 
of each property (street address, district, city, and country please).  
*/ 

SELECT 
	staff.first_name AS "Manager_First_Name", 
	staff.last_name AS "Manager_Last_Name",
	address.address AS "Full_Address",
	address.district AS "District",
	city.city AS "City",
	country.country AS "Country"
FROM store
	LEFT JOIN staff
		ON store.manager_staff_id = staff.staff_id  -- Performs the LEFT JOIN between the store and staff to match the staff_id with manager_staff_id
	LEFT JOIN address
		ON staff.address_id = address.address_id   -- Performs the LEFT JOIN between the staff and address
	LEFT JOIN city                                              
		ON address.city_id = city.city_id          -- Performs the LEFT JOIN between the address and city
	LEFT JOIN country
		ON city.country_id = country.country_id    -- Performs the LEFT JOIN between the city and country
        
	
/*
Q2.	I would like to get a better understanding of all of the inventory that would come along with the business. 
Please pull together a list of each inventory item you have stocked, including the store_id number, 
the inventory_id, the name of the film, the film’s rating, its rental rate and replacement cost. 
*/

SELECT 
	I.store_id, 
    I.inventory_id,
    F.title,
    F.rating,
    F.replacement_cost
    
FROM inventory AS I
	LEFT JOIN film AS F
		ON I.film_id = F.film_ID
LIMIT 5000;


/* 
Q3.	From the same list of films you just pulled, please roll that data up and provide a summary level overview 
of your inventory. We would like to know how many inventory items you have with each rating at each store. 
*/

SELECT 
    I.store_id, 
    F.rating,
    COUNT(I.inventory_id) AS "Number_Of_Inventory_Items"
FROM inventory AS I
	LEFT JOIN film AS F
		ON I.film_id = F.film_ID
GROUP BY
	I.store_id, 
    F.rating;


/* 
Q4. Similarly, we want to understand how diversified the inventory is in terms of replacement cost. We want to 
see how big of a hit it would be if a certain category of film became unpopular at a certain store.
We would like to see the number of films, as well as the average replacement cost, and total replacement cost, 
sliced by store and film category. 
*/ 

SELECT 
    store_id, 
    category.name AS "Category_Name",
    COUNT(inventory.inventory_id) AS "Number_Of_Films",
    AVG(film.replacement_cost) AS "Average_Replacement_Cost",
    SUM(film.replacement_cost) AS "Total_Replacement_Cost"
FROM inventory
		LEFT JOIN film
			ON inventory.film_id =  film.film_id
		LEFT JOIN film_category
			ON film.film_id = film_category.film_id
		LEFT JOIN category
			ON category.category_id = film_category.category_id
GROUP BY
	store_id,
    category.name

ORDER BY 
	SUM(film.replacement_cost) DESC;

/*
Q5.	We want to make sure you folks have a good handle on who your customers are. Please provide a list 
of all customer names, which store they go to, whether or not they are currently active, 
and their full addresses – street address, city, and country. 
*/

SELECT
	customer.first_name AS "Customer_First_Name",
    customer.last_name AS "Customer_Last_Name",
    customer.store_id AS "Store_Name",
    customer.active AS "Active_Status",
    address.address AS "Full_Address",
    city.city "City_Name",
    country.country AS "Country_Name"
FROM customer

LEFT JOIN address
	ON customer.address_id = address.address_id
LEFT JOIN city
	ON address.city_id = city.city_id
LEFT JOIN country
	ON city.country_id = country.country_id

/*
Q6.	We would like to understand how much your customers are spending with you, and also to know 
who your most valuable customers are. Please pull together a list of customer names, their total 
lifetime rentals, and the sum of all payments you have collected from them. It would be great to 
see this ordered on total lifetime value, with the most valuable customers at the top of the list. 
*/

SELECT 
	customer.first_name AS "Customer_First_Name",
    customer.last_name AS "Customer_Last_Name",
    COUNT(rental.rental_id) AS "Total_Number_Of_Rentals",
    SUM(payment.amount) AS "Total_Amount_Collected"
FROM customer
	LEFT JOIN rental
		ON customer.customer_id = rental.customer_id
	LEFT JOIN payment
		ON rental.rental_id = payment.rental_id
GROUP BY 
	customer.first_name,
    customer.last_name
ORDER BY
     SUM(payment.amount) DESC;

/*
Q7. My partner and I would like to get to know your board of advisors and any current investors.
Could you please provide a list of advisor and investor names in one table? 
Could you please note whether they are an investor or an advisor, and for the investors, 
it would be good to include which company they work with. 
*/

SELECT 
	"Investor" as "Type",
    first_name AS "First_Name",
    last_name AS "Last_Name",
    company_name AS "Company_Name"
FROM investor

UNION

SELECT 
	"Advisor" as "Type",
    first_name AS "First_Name",
    last_name AS "Last_Name",
    NULL
FROM advisor;


/*
Q8. We're interested in how well you have covered the most-awarded actors. 
Of all the actors with three types of awards, for what % of them do we carry a film?
And how about for actors with two types of awards? Same questions. 
Finally, how about actors with just one award? 
*/

SELECT 
	CASE
		WHEN actor_award.awards = 'Emmy, Oscar, Tony ' THEN '3 Awards'
        WHEN actor_award.awards IN ('Emmy, Oscar', 'Emmy, Tony', 'Oscar, Tony') THEN '2 Awards'
        ELSE '1 Award'
	END AS Number_Of_Awards,
    AVG(CASE WHEN actor_award.actor_id is NULL THEN 0 ELSE 1 END) * 100 AS "Percentage_With_Atleast_1_Film"
    
FROM actor_award

GROUP BY
CASE
		WHEN actor_award.awards = 'Emmy, Oscar, Tony ' THEN '3 Awards'
        WHEN actor_award.awards IN ('Emmy, Oscar', 'Emmy, Tony', 'Oscar, Tony') THEN '2 Awards'
        ELSE '1 Award'
	END


