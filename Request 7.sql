# 7. Get the complete report of the Gross sales amount for the customer “Atliq Exclusive” for each month. This analysis helps to get an idea of low and high-performing months and take strategic decisions #

select concat(monthname(date),' (',year(f.date),')') as 'month', f.fiscal_year,
round(sum(f.sold_quantity*g.gross_price),2) as 'total_sales' 
from fact_sales_monthly f 
join dim_customer d 
on f.customer_code = d.customer_code 
join fact_gross_price g
on g.product_code = f.product_code
where customer = 'Atliq Exclusive'
group by f.date;