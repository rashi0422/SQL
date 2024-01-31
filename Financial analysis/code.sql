### create function for fiscal_year ##

CREATE FUNCTION `get_fiscal_year`(
    Calendar_date date
) RETURNS int
    DETERMINISTIC
BEGIN
      declare fiscal_year INT;
      SET fiscal_year = YEAR (date_add(calendar_date, interval 4 month));
RETURN fiscal_year;
END

--------------------------------------------------------------------------
### create function for fiscal_quartar ##

CREATE FUNCTION `get_fiscal_quarter`(
     calendar_date date
) RETURNS char(2) 
    DETERMINISTIC
BEGIN
     declare m tinyint;
     declare qtr char(2);
     set m = month(calendar_date);
     
     case
         when m in (9,10,11) then 
            set qtr = "Q1" ;
         when m in (12,1,2) then
		      	set qtr = "Q2" ;
		     when m in (3,4,5) then
            set qtr = "Q3";
		     when m in (6,7,8) then
            set qtr = "Q4";
    end case;
RETURN qtr;
END
-------------------------------------------------------------------
## Find the Total Sales by croma store in 2021 in Quarter 4 ##

select * from fact_sales_monthly 
where 
   customer_code = 90002002  and 
   get_fiscal_year(date) = 2021 and
   get_fiscal_quarter(date) = "Q4"
order by date asc
limit 1000000;

---------------------------------------------------------------------
## Gross monthly Total sales report for croma ##

select 
     s.date, s.product_code,
     p.product, p.variant , s.sold_quantity,
     g.gross_price,
     round(g.gross_price*s.sold_quantity,2) as gross_price_total
from fact_sales_monthly s
join dim_product p 
on p.product_code = s.product_code
join fact_gross_price g
on  
     g.product_code = s.product_code and 
     g.fiscal_year=get_fiscal_year(s.date)
where 
   customer_code = 90002002  and 
   get_fiscal_year(date) = 2021 and
   get_fiscal_quarter(date) = "Q4"
order by date asc
limit 1000000;

------------------------------------------------------------
## Generate a yearly report for Croma India where there are two columns:
1. Fiscal Year
2. Total Gross Sales amount In that year from Croma

select 
    get_fiscal_year(date) as fiscal_year,
    sum(round(sold_quantity*g.gross_price,2)) as yearly_sales
from fact_sales_monthly s 
join fact_gross_price g
on 
   g.fiscal_year=get_fiscal_year(s.date) and
   g.product_code = s.product_code
where
     customer_code = 90002002
group by get_fiscal_year(date)
order by fiscal_year;

-------------------------------------------------------------------
----- monthly sales -----------
select 
    s.date,
    sum(round(sold_quantity*g.gross_price,2)) as monthly_sales
from fact_sales_monthly s 
join fact_gross_price g
on 
   g.fiscal_year=get_fiscal_year(s.date) and
   g.product_code = s.product_code
where
     customer_code = 90002002
group by date;


