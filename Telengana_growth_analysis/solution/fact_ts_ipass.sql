SELECT * FROM telangana_growth.fact_ts_ipass;

# 1.List down the top 5 sectors that have witnessed the most significant investments in FY 2022.
select sector, round(sum(Investment_in_cr),2) as 'Total_investment'
from fact_ts_ipass f
join dim_date d
on f.month = d.month
where fiscal_year = 2022
group by sector
order by Total_investment desc
limit 5 ;

# 2. List down the top 3 districts that have attracted the most significant sector investments during FY 2019 to 2022? What factors could have
# led to the substantial investments in these particular districts?
select district, round(sum(Investment_in_cr),2) as 'Total_investment_in_cr'
from fact_ts_ipass f
join dim_date d
on f.month = d.month
join dim_districts di 
on di.dist_code = f.dist_code
group by district
order by Total_investment_in_cr desc
limit 3 ;


# 3. Is there any relationship between district investments, vehicles
#sales and stamps revenue within the same district between FY 2021 and 2022?
with Output1 as (select district,round(sum(investment_in_cr),2) as 'Investment_in_cr'
from fact_ts_ipass f 
join dim_date d 
on f.month = d.month
join dim_districts di 
on di.dist_code = f.dist_code 
where fiscal_year = 2021 or fiscal_year = 2022
group by district),
output2 as (select district, sum(estamps_challans_rev/1000000) as 'estamps_revenue'
from fact_stamps f
join dim_districts d 
on f.dist_code = d.dist_code
join dim_date da
on da.month = f.month
where fiscal_year = 2021 or fiscal_year = 2022
group by district
),
output3 as ( select district, round(sum(fuel_type_petrol + fuel_type_diesel + fuel_type_electric + fuel_type_others),2) as 'vechicle_revenue'
from fact_transport f
join dim_districts d 
on f.dist_code = d.dist_code
join dim_date da
on da.month = f.month
where fiscal_year = 2021 or fiscal_year = 2022
group by district
)
select A.district,  A.Investment_in_cr, C.vechicle_revenue,
concat(round(B.estamps_revenue,0), ' M') as 'estamps_revenue_in_mln'
from output1 A 
join output2 B on A.district = B.district 
join output3 C on A.district = C.district ;

# 4. Are there any particular sectors that have shown substantial investment in multiple districts between FY 2021 and 2022?
select sector,count(distinct district) as 'districts', round(sum(investment_in_cr),2) as 'total_investment_in_cr'
from fact_ts_ipass f 
join dim_districts d 
on f.dist_code = d.dist_code
group by sector
order by total_investment_in_cr desc
limit 10;

# 5. Can we identify any seasonal patterns or cyclicality in the investment trends for specific sectors? Do certain sectors
 # experience higher investments during particular months?
select sector,mmm,round(sum(investment_in_cr),2) as 'total_investment_cr' 
from fact_ts_ipass f 
join dim_date d
on f.month = d.month
group by sector,mmm
order by sector asc;


 