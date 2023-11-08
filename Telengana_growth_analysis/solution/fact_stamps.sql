SELECT * FROM telangana_growth.fact_stamps;


# 1. How does the revenue generated from document registration vary across districts in Telangana? List down the top 5 districts that showed
the highest document registration revenue growth between FY 2019 and 2022  #

with output1 as 
(select di.district , sum(documents_registered_rev) as 'total_2019'
from fact_stamps f
join dim_date d
on d.month = f.month
join dim_districts di
on di.dist_code = f.dist_code
where fiscal_year = 2019 group by district),
output2 as
(select di.district, sum(documents_registered_rev) as 'total_2022'
from fact_stamps f
join dim_date d
on d.month = f.month
join dim_districts di
on di.dist_code = f.dist_code
where fiscal_year = 2022 group by district)
select A.district, round((total_2022 - total_2019)/total_2019,2)*100 as 'Growth_%'
from output1 A join output2 B on A.district = B.district
limit 5;



# 2. How does the revenue generated from document registration compare to the revenue generated from e-stamp challans across districts? List
down the top 5 districts where e-stamps revenue contributes significantly more to the revenue than the documents in FY 2022?

with Output as (select  di.district, d.fiscal_year,
round(sum(documents_registered_rev/1000000),2) as 'rev_from_docu', 
round(sum(estamps_challans_rev/1000000),2) as 'rev_from_estamp' 
from fact_stamps f
join dim_date d 
on f.month = d.month
join dim_districts di 
on di.dist_code = f.dist_code
where d.fiscal_year = 2022 
group by district)
select district, fiscal_year, concat(rev_from_docu , ' M') as 'rev_from_docu_mln' , concat( rev_from_estamp, ' M') as 'rev_from_estamp_mln' 
from Output 
where rev_from_docu < rev_from_estamp limit 5;

# 3. Is there any alteration of e-Stamp challan count and document registration count pattern since the implementation of e-Stamp
challan? If so, what suggestions would you propose to the government?

select d.fiscal_year , d.month ,
sum(documents_registered_cnt) as 'total_docu' , sum(estamps_challans_cnt) as 'total_estamp'
from fact_stamps f
join dim_date d 
on f.month = d.month
group by fiscal_year;

# 4. Categorize districts into three segments based on their stamp registration revenue generation during the fiscal year 2021 to 2022.

select district , case 
when estamps_challans_rev between 0 and 5000000 then 'low_revenue'
when estamps_challans_rev between 5000000 and 20000000 then 'Medium_revenue'
when estamps_challans_rev > 20000000 then 'High_revenue'
end as Category  , estamps_challans_rev 
from fact_stamps f
join dim_districts d
on f.dist_code = d.dist_Code 
join dim_date da
on da.month = f.month
where fiscal_year = 2021 or fiscal_year = 2022;

