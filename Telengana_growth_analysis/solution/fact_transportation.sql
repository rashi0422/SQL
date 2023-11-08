SELECT * FROM telangana_growth.fact_transport;

# 1. Investigate whether there is any correlation between vehicle sales and specific months or seasons in different districts. Are there any months
or seasons that consistently show higher or lower sales rate, and if yes, what could be the driving factors? (Consider Fuel-Type category only)

select district,mmm,sum(fuel_type_petrol) as 'vehicle_sales'
from fact_transport f 
join dim_date d
on f.month = d.month
join dim_districts di
on f.dist_code = di.dist_code
group by mmm,district
order by district;


# 2. How does the distribution of vehicles vary by vehicle class (MotorCycle, MotorCar, AutoRickshaw, Agriculture) across different
districts? Are there any districts with a predominant preference for a specific vehicle class? Consider FY 2022 for analysis.

select district, fiscal_year, 
sum(vehicleClass_MotorCycle) as 'Motor_cycle', 
sum(vehicleClass_MotorCar) as 'Motor_car', 
sum(vehicleClass_AutoRickshaw) as 'Auto_rickshaw', 
sum(vehicleClass_Agriculture) as 'Agriculture'
from fact_transport f
join dim_date d
on f.month = d.month 
join dim_districts di 
on f.dist_code = di.dist_Code
where fiscal_year = 2022
group by district;

# 3. List down the top 3 and bottom 3 districts that have shown the highest and lowest vehicle sales growth during FY 2022 compared to FY
2021? (Consider and compare categories: Petrol, Diesel and Electric)

# Top 3 #

with output1 as (select district, 
sum(fuel_type_petrol) as 'Petrol_2021' , 
sum(fuel_type_diesel) as 'diesel_2021', 
sum(fuel_type_electric) as 'electric_2021'
from fact_transport f
join dim_date d 
on f.month = d.month
join dim_districts di
on di.dist_code = f.dist_code 
where fiscal_year = 2021
group by district ),
output2 as (select district, 
sum(fuel_type_petrol) as 'Petrol_2022' , 
sum(fuel_type_diesel) as 'diesel_2022', 
sum(fuel_type_electric) as 'electric_2022'
from fact_transport f
join dim_date d 
on f.month = d.month
join dim_districts di
on di.dist_code = f.dist_code 
where fiscal_year = 2022
group by district )
select A.district, concat(round(((Petrol_2022 - Petrol_2021)/Petrol_2021)* 100,0),' %') as 'petrol_growth_%',
concat(round(((diesel_2022 - diesel_2021)/diesel_2021)*100,0),' %') as 'diesel_growth_%',
concat(round(((electric_2022 - electric_2021)/electric_2021)*100,0), ' %') as 'electric_growth_%'
from output1 A join output2 B on A.district = B.district;


