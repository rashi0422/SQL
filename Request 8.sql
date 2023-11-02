# 8. In which quarter of 2020, got the maximum total_sold_quantity? The final output contains these fields sorted by the total_sold_quantity #

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