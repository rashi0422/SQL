--- Is for error 1055 --
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

# Request 1. Provide the list of markets in which customer "Atliq Exclusive" operates its business in the APAC region #

select market,customer,region 
from dim_customer 
where customer = 'Atliq Exclusive' and region = 'APAC' 
group by market;

# Request 2. What is the percentage of unique product increase in 2021 vs. 2020? The final output contains these fields #

select X.A as unique_product_2020, Y.B as unique_product_2021 , round((B-A)*100/A,2) as  '% change' 
from (
(select count(distinct product_code) as 'A' from fact_sales_monthly where fiscal_year = 2020) as X, 
(select count(distinct product_code) as 'B' from fact_sales_monthly where fiscal_year = 2021) as Y 
) ;

# Request 3. Provide a report with all the unique product counts for each segment and sort them in descending order of product counts #

select segment , count(product) as 'product_count' 
from dim_product 
group by segment 
order by product_count desc;

# Request 4. Which segment had the most increase in unique products in 2021 vs 2020? The final output contains these fields #

with output1 as (select segment,count(product) as 'product_count_2020'
from dim_product d 
join fact_gross_price g 
on g.product_code = d.product_code 
where fiscal_year = 2020
group by segment),
output2 as (select segment,count(product) as 'product_count_2021'
from dim_product d 
join fact_gross_price g 
on g.product_code = d.product_code 
where fiscal_year = 2021
group by segment)
select output1.segment,output1.product_count_2020,output2.product_count_2021,
Output2.product_count_2021 - output1.product_count_2020 as difference
from Output1 join output2 
on output1.segment = output2.segment 
order by segment asc;

# Request 5. Get the products that have the highest and lowest manufacturing costs #

(select d.product_code , d.product, f.manufacturing_cost from fact_manufacturing_cost f
join dim_product d on f.product_code = d.product_code 
group by d.product order by f.manufacturing_cost desc limit 1 )
UNION
(select d.product_code , d.product, f.manufacturing_cost from fact_manufacturing_cost f
join dim_product d on f.product_code = d.product_code 
group by d.product order by f.manufacturing_cost asc limit 1 );

# Request 6. Generate a report which contains the top 5 customers who received an average high pre_invoice_discount_pct for the fiscal year 2021 and in the Indian market #

select d.customer_code,customer , round(avg(pre_invoice_discount_pct),4) as 'average'
from dim_customer d
join fact_pre_invoice_deductions f
on d.customer_code = f.customer_code 
where market = 'India' and fiscal_year = 2021
group by customer
order by average desc
limit 5;

# Request 7. Get the complete report of the Gross sales amount for the customer “Atliq Exclusive” for each month. This analysis helps to get an idea of low and high-performing months and take strategic decisions #

select concat(monthname(date),' (',year(f.date),')') as 'month', f.fiscal_year,
round(sum(f.sold_quantity*g.gross_price),2) as 'total_sales' 
from fact_sales_monthly f 
join dim_customer d 
on f.customer_code = d.customer_code 
join fact_gross_price g
on g.product_code = f.product_code
where customer = 'Atliq Exclusive'
group by f.date;

# Request 8. In which quarter of 2020, got the maximum total_sold_quantity? The final output contains these fields sorted by the total_sold_quantity #

select 
case 
when date between '2019-09-01' and '2019-11-01' then 1
when date between '2019-12-01' and '2020-02-01' then 2
when date between '2020-03-01' and '2020-05-01' then 3 
when date between '2020-06-01' and '2020-08-01' then 4
end as quarter,
sum(sold_quantity) as 'total_quantity' 
from fact_sales_monthly 
where fiscal_year = 2020
group by Quarter
order by Quarter asc;

# Request 9.  Which channel helped to bring more gross sales in the fiscal year 2021 and the percentage of contribution? #

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

# Request 10. Get the Top 3 products in each division that have a high total_sold_quantity in the fiscal_year 2021? #

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
from output1 
join output2 
on output1.product_code = output2.product_code 
where output2.rank_order in (1,2,3);





