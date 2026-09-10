use resturant ;
select * from customer;
    -- Q1 What is the total amount each customer spent at the restaurant?
    SELECT 
    c.customer_id, SUM(price) AS total_amount
FROM
    menu AS m
        JOIN
    sales AS s ON s.product_id = m.product_id
        JOIN
    customer AS c ON c.customer_id = s.customer_id
GROUP BY customer_id;
     
-- Q2 How many days has each customer visited the restaurant? 
    SELECT 
    customer_id, COUNT(DISTINCT order_date) AS visit_days
FROM
    sales
GROUP BY customer_id
ORDER BY visit_days DESC; 

-- Q3 What was the first item from the menu purchased by each customer?
select customer_id, order_date, product_name from ( SELECT s.customer_id, s.order_date, m.product_name, 
ROW_NUMBER() over( partition by customer_id 
order by order_date) as rn
 from sales as s
 join menu as m on m.product_id = s.product_id) as t
 where rn = 1;
 
 -- Q4 What is the most purchased item on the menu and how many times was it purchased by all customers
 SELECT 
    product_name, COUNT(order_date) AS times_purchased
FROM
    sales AS s
        JOIN
    menu AS m ON m.product_id = s.product_id
GROUP BY product_name
ORDER BY times_purchased DESC
limit 1;

-- Q5 Which item was the most popular for each customer?
SELECT customer_id, product_name, times_purchased from ( select s.customer_id, m.product_name, 
count(order_date) as times_purchased,
 RANK() over(PARTITION BY customer_id order by count(order_date) desc) as rnk
 from   sales as s
 join menu as m on m.product_id = s.product_id
 GROUP BY s.customer_id, m.product_name  ) as t
 where rnk =1; 
 
 -- Q6 Which item was purchased first by the customer after they became a member?
 SELECT customer_id,product_name, order_date FROM ( select c.customer_id, m.product_name, s.order_date,
 row_number() over( PARTITION BY customer_id
 ORDER BY order_date) rn
  from sales as s
 join menu as m on m.product_id = s.product_id
 join customer c on c.customer_id = s.customer_id
  WHERE s.order_date >= c.join_date) t
 WHERE rn = 1;

 -- Q7 Which item was purchased just before the customer became a member?
 SELECT customer_id,
 product_name, 
 order_date FROM ( select c.customer_id, 
 m.product_name, s.order_date,
 row_number() over( PARTITION BY customer_id
 ORDER BY order_date desc) rn
  from sales as s
 join menu as m on m.product_id = s.product_id
 join customer c on c.customer_id = s.customer_id
  WHERE s.order_date < c.join_date) t
 WHERE rn = 1;
 
 -- Q8 What is the total items and amount spent for each member before they became a member?
 SELECT 
    c.customer_id,
    COUNT(s.product_id) AS total_items,
    SUM(price) AS total_amount_spent
FROM
    sales AS s
        JOIN
    menu AS m ON m.product_id = s.product_id
        JOIN
    customer AS c ON c.customer_id = s.customer_id
WHERE
    order_date < join_date
GROUP BY s.customer_id;
 
/* Q9 If each $1 spent equates to 10 points and sushi has a 2x points multiplier -
 how many points would each customer have? */
 
 SELECT 
    s.customer_id,
    SUM(
        CASE 
            WHEN m.product_name = 'sushi' THEN m.price * 20
            ELSE m.price * 10
        END
    ) AS total_points
FROM sales s
JOIN menu m
    ON s.product_id = m.product_id
GROUP BY s.customer_id;

 
/* Q10 In the first week after a customer joins the program (including their join date) 
they earn 2x points on all items, 
not just sushi - how many points do customer A and B have at the end of January? */
SELECT 
    s.customer_id,
    SUM(CASE
        WHEN s.order_date BETWEEN c.join_date AND DATE_ADD(c.join_date, INTERVAL 6 DAY) THEN m.price * 20
        WHEN m.product_name = 'sushi' THEN m.price * 20
        ELSE m.price * 10
    END) AS total_points
FROM
    sales s
        JOIN
    menu m ON s.product_id = m.product_id
        JOIN
    customer c ON s.customer_id = c.customer_id
WHERE
    s.order_date <= '2021-01-31'
        AND s.customer_id IN ('A' , 'B')
GROUP BY s.customer_id;

 


 

select * FROM customer;
select * from menu;
select * from sales ;