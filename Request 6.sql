# 6. Generate a report which contains the top 5 customers who received an average high pre_invoice_discount_pct for the fiscal year 2021 and in the Indian market #

select d.customer_code,customer , round(avg(pre_invoice_discount_pct),4) as 'average'
from dim_customer d
join fact_pre_invoice_deductions f
on d.customer_code = f.customer_code 
where market = 'India' and fiscal_year = 2021
group by customer
order by average desc
limit 5;