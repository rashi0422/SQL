# 5. Get the products that have the highest and lowest manufacturing costs #

(select d.product_code , d.product, f.manufacturing_cost from fact_manufacturing_cost f
join dim_product d on f.product_code = d.product_code 
group by d.product order by f.manufacturing_cost desc limit 1 )
UNION
(select d.product_code , d.product, f.manufacturing_cost from fact_manufacturing_cost f
join dim_product d on f.product_code = d.product_code 
group by d.product order by f.manufacturing_cost asc limit 1 );
