use mckproj;
select * from mck_retail_proj limit 10;
desc mck_retail_proj;

SELECT COUNT(*) FROM mck_retail_proj;

SELECT DISTINCT category
FROM mck_retail_proj;

# highest selling products  /
CREATE VIEW highest_selling_products AS
SELECT `Product ID`, SUM(`Units Sold`) AS total_units_sold 
FROM mck_retail_proj
GROUP BY `Product ID`
ORDER BY total_units_sold DESC
LIMIT 10;

#total revenue  /
CREATE VIEW Total_revenue as
select sum(`Units Sold` * `Price`) as total_revenue from mck_retail_proj; 

#revenue by category /
CREATE VIEW category_revenue AS
select Category,sum(`Units Sold` * `Price`) as revenue from mck_retail_proj group by Category order by revenue; 

#AVG demand forcast by category`Demand Forecast` /
CREATE VIEW AVG_DEMAND_FORECAST AS
select Category,avg(`Demand Forecast`) as AVG_DEMAND from mck_retail_proj group by Category;

# MOST DISCOUNTED CATEGORIES /
CREATE VIEW AVG_discounted_prod AS
select Category,avg(Discount) as AVG_discount from mck_retail_proj group by Category order by AVG_discount desc ;

# region wise sales /
CREATE VIEW region_sales AS
select Region,sum(`Units Sold`) as region_sales from mck_retail_proj group by Region order by region_sales desc;

# seasonal sales analysis /
CREATE VIEW seasonal_sales AS
select Seasonality, sum(`Units Sold`) as seasonal_sales from mck_retail_proj group by Seasonality order by seasonal_sales desc;


# weather impact on sales /
CREATE VIEW AVG_SALES_WEATHER AS
select `Weather Condition`,avg(`Units Sold`) as avg_sales_wthr from mck_retail_proj  group by  `Weather Condition`;


# holiday impact on sales  /
CREATE VIEW AVG_SALES_HOLIDAY AS
SELECT `Holiday/Promotion`,AVG(`Units Sold`) AS avg_units_sold_holday FROM mck_retail_proj GROUP BY `Holiday/Promotion`;



# inventory status  /
CREATE VIEW inventory_status AS
select `Product ID`,`Inventory Level` ,
case 
	when `Inventory Level` =0 then "out of stock"
    when `Inventory Level` <100 then "low on stock"
    else "in stock"
end as inventory_status
from mck_retail_proj ;

# top 10 most expensive products  /\
CREATE VIEW MOST_EXPENSIVE_PROD AS
select `Product ID`,Price from mck_retail_proj order by price desc limit 10;


#view sales summary /
create view sales_summary as 
select
Category,
Region,
sum(`Units Sold`) as total_sales,
sum(`Units Sold` * Price) as revenue
from mck_retail_proj 
group by Category ,Region;
SELECT * FROM sales_summary;

# monthly sales /
CREATE VIEW monthly_sales AS
select month(Date) as month,sum(`Units Sold`) as monthly_sales from mck_retail_proj GROUP BY month ORDER BY month;

#creating index ,assigning number to category for easy acces
CREATE INDEX idx_category
ON mck_retail_proj(Category);

#alter the category dattype to varchar cause the key lenght in category(text) doesnt have key lenght limit
alter table mck_retail_proj
modify Category varchar(100);


#creating revenue grouped by holiday
create view holidaY_nonholiday_revenue AS
SELECT 
    CASE 
        WHEN `Holiday/Promotion` = 1 THEN 'Holiday'
        ELSE 'Non-Holiday'
    END AS holiday_type,
    
    sum(`Units Sold` * `Price`) AS total_revenue	

FROM mck_retail_proj`Holiday/Promotion`

GROUP BY `Holiday/Promotion`;



# create view  category_revenue as
create view  top_category_revenue as
SELECT 
    Category,
    SUM(revenue) AS total_revenue
FROM sales_summary
GROUP BY Category
ORDER BY total_revenue DESC
LIMIT 3;


SELECT 
    `Date`,
    SUM(revenue) AS total_revenue
FROM sales_summary
GROUP BY `Date`
ORDER BY `Date`;