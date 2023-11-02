# 3. Provide a report with all the unique product counts for each segment and sort them in descending order of product counts #

select segment , count(product) as 'product_count' 
from dim_product 
group by segment 
order by product_count desc;