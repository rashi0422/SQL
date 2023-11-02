# 9.  Which channel helped to bring more gross sales in the fiscal year 2021 and the percentage of contribution? #

with output as (
select channel, round(sum(gross_price * sold_quantity/1000000),2) as 'Gross_sales_mln'
from dim_customer d
join fact_sales_monthly s
on d.customer_code = s.customer_code 
join fact_gross_price g
on g.product_code = s.product_code
where s.fiscal_year = 2021
group by channel)
select channel, concat(gross_sales_mln, ' M') as gross_sales_mln , 
concat(round(gross_sales_mln*100/total,2), ' %') as percentage
from (
(select sum(gross_sales_mln) as total from output) A ,
(select * from output ) B 
)
order by percentage;

