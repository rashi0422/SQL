# 10. Get the Top 3 products in each division that have a high total_sold_quantity in the fiscal_year 2021? #

with output1 as (select division, f.product_code , product , fiscal_year,
sum(sold_quantity) as total_sold_quantity
from dim_product d 
join fact_sales_monthly f
on d.product_code = f.product_code
where fiscal_year= 2021
group by product),
Output2 as
(select division, product_code , product, total_sold_quantity, 
rank() over (partition by division order by total_sold_quantity desc) as 'Rank_order'
from output1)
select output1.division , output1.product_code, output1.product,output1.total_sold_quantity,output2.rank_order
from output1 join output2 
on output1.product_code = output2.product_code 
where output2.rank_order in (1,2,3);

