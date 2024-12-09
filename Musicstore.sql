select * from employee
-- who is the senior most employee based on job title
select * from employee
order by levels desc
limit 1;

-- which countries have the most invoices?
select * from invoice;
select billing_country,count(billing_country) as c
from invoice
group by billing_country
order by c desc;

-- what are the top 3 values of total invoice
select * from invoice;
select invoice_id, sum(total) as total
from invoice
group by invoice_id
order by total desc
limit 3;

-- which city has the best customers? write query that return one city has the highest sum of invoice totals
select * from invoice;
select billing_city, sum(total) as Sales
from invoice
group by billing_city
order by Sales desc;

-- who is the best customer? Write a query that return the person who has spent the most money
select * from invoice;
select customer.customer_id, customer.first_name, customer.last_name, sum(invoice.total) as Money_spent
from invoice 
join customer on customer.customer_id = invoice.customer_id
group by customer.customer_id
order by Money_spent desc;

-- write the query to return first name, last name, email, genre
select * from genre;
select * from customer;
select * from invoice;
select * from invoice_line;
select * from track;
select distinct(customer.email) as email_id, customer.first_name, customer.last_name
from customer 
join Invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id 
where track_id in 
		( select track_id from track join genre on track.genre_id = genre.genre_id
			where genre.name like 'Rock')
order by email;

-- return artist name and total count of top 10 rock bands
select * from genre;
select * from artist;
select artist.artist_id, artist.name, count(artist.artist_id) as number_of_song
from track
join album on track.album_id = album.album_id
join artist on album.artist_id = artist.artist_id
join genre on track.genre_id = genre.genre_id
where genre.name like 'Rock'
group by artist.artist_id 
order by number_of_song desc;


-- return all the track names that have asong lenth longer than the average song length. Return the miliseconds for each track.
-- order by the song length with longest songs listed first
select name, milliseconds
from track
where milliseconds > (select avg(milliseconds) as avg_track_length from track)
order by milliseconds desc;

-- return how much spent on a artist
select * from invoice_line;
select * from album;
with best_selling_artist AS (
		SELECT artist.artist_id AS artist_id, artist.name as artist_name,
		SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
		FROM invoice_line
		Join track on track.track_id = invoice_line.track_id
		join album on album.album_id = track.album_id
		join artist on artist.artist_id = album.artist_id
		group by 1
		order by 3 desc
		LIMIT 1
		)

select c.customer_id, c.first_name,c.last_name, bsa.artist_name,
sum(il.unit_price*il.quantity) as amount_spent
from invoice i
Join customer c on c.customer_id = i.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
join track t on t.track_id = il.track_id
join album alb on alb.album_id = t.album_id
join best_selling_artist bsa on bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
order by 5 desc;

-- we want to find most popular genres with highest amount of purchases
with popular_genre as 
(select count(invoice_line.quantity) as purchases, customer.country, genre.name, genre.genre_id,
ROW_NUMBER() OVER (PARTITION BY CUSTOMER.COUNTRY ORDER BY COUNT(INVOICE_LINE.QUANTITY) DESC) AS ROWNO
FROM INVOICE_LINE
JOIN INVOICE ON INVOICE.INVOICE_ID = INVOICE.INVOICE_ID
JOIN CUSTOMER ON CUSTOMER.CUSTOMER_ID = INVOICE.CUSTOMER_ID
JOIN TRACK ON TRACK.TRACK_ID = INVOICE_LINE.TRACK_ID
JOIN GENRE ON GENRE.GENRE_ID = TRACK.GENRE_ID
GROUP BY 2,3,4
ORDER BY 2 ASC, 1 DESC
)
SELECT * FROM POPULAR_GENRE WHERE ROWNO <= 1;


-- WRITE A QUERY TO CUSTOMER SPENDING MOST ON MUSIC
-- WRITE A QUERY THAT RETURNS THE COUNTRY WITH TOP CUSTOMER AND HOW MUCH SPENT
-- WHERE THR TOP AMOUNT IS SHARED, PROVIDE ALL CUSTOMER WHO SPENT THIS AMOUNT

with RECURSIVE
	customer_with_country as (
select customer.customer_id,first_name,last_name,billing_country,sum(total) as total_spending
from invoice
join customer on customer.customer_id = invoice.customer_id
group by 1,2,3,4
order by 1,5 desc
	),

	country_max_spending as (
select billing_country, MAX(total_spending) as max_spending
from customer_with_country
group by billing_country)

select cc.billing_country, cc.total_spending,cc.first_name, cc.last_name
From customer_with_country cc
join country_max_spending ms
on cc.billing_country = ms.billing_country
where cc.total_spending = ms.max_spending
order by 1;











