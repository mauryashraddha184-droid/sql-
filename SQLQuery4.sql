create table Sales_store(
transaction_id varchar(15),customer_id varchar(15),customer_name varchar(30),
customer_age int,gender varchar(15),product_id varchar(15),product_name varchar(15),
product_category varchar(15),quantiy int,
prce float,payment_mode varchar(15),
purchase_date Date,
time_of_purchase time,status varchar(15));
set dateformat dmy
bulk insert Sales_store
from'C:\temp\Sales.csv'
with(
firstrow=2,
fieldterminator=',',
rowterminator='\n'
);
select *from Sales_store;

select* into sales from Sales_store;

--data cleaning
select transaction_id from sales group by transaction_id having 
count(transaction_id)>1;

with cte as(
select *, row_number() over 
(partition by transaction_id order by transaction_id)as  row_num from sales
)
--delete from cte where row_num=2;
select *from cte
where transaction_id in('TXN240646',
'TXN342128',
'TXN855235',
'TXN981773');
--correction of row name
exec sp_rename 'sales.quantiy','quantity','column';
exec sp_rename 'sales.prce','price','column';
--to check the datatype
select column_name,data_type 
from information_schema.columns
where table_name='sales';
--to check the null values
DECLARE @sql NVARCHAR(MAX) = '';

SELECT @sql = @sql + 
    QUOTENAME(c.name) + ' IS NULL OR '
FROM sys.columns c
WHERE c.object_id = OBJECT_ID('schema_name.table_name');

-- Remove last OR
SET @sql = LEFT(@sql, LEN(@sql) - 3);

SET @sql = 'SELECT * FROM schema_name.table_name WHERE ' + @sql;

EXEC sp_executesql @sql;
-- to check null count
declare @sql nvarchar(max)='';

select @sql=string_agg(
'select '''+column_name+'''as 
columnname,
count(*)as nullcount
from'+quotename(table_schema)+'.sales
where'+quotename(column_name)+' is 
null ',
' union all '
)
within group(order by column_name)
from information_schema.columns
where table_name='sales';

exec sp_executesql @sql;
--treating null values
select *
from sales
where transaction_id is null
or
customer_id is null
or
customer_name is null
or
customer_age is null
or
gender is null
or
product_id is null
or
product_name is null
or
product_category is null
or 
quantity is null
or
price is null
or
payment_mode is null
or
purchase_date is null
or
time_of_purchase is null
or
status is null

delete from sales
where transaction_id is null

DECLARE @sql NVARCHAR(MAX) = '';

SELECT @sql = @sql + 
    QUOTENAME(c.name) + ' IS NULL OR '
FROM sys.columns c
WHERE c.object_id = OBJECT_ID('schema_name.table_name');

-- Remove last OR
SET @sql = LEFT(@sql, LEN(@sql) - 3);

SET @sql = 'SELECT * FROM schema_name.table_name WHERE ' + @sql;

EXEC sp_executesql @sql;

SELECT *FROM Sales 
where customer_name='Damini Raju'

update sales
set customer_id='CUST1401'
where transaction_id='TXN985663'

SELECT *FROM Sales 
where customer_id='CUST1003'

update sales
set customer_name='Mahika Saini',customer_age=35,gender='Male'
where transaction_id='TXN432798'

select *from sales

--data cleaning
select distinct gender
from sales

update sales 
set gender='M'
where gender='Male'

update sales 
set gender='F'
where gender='Female'

select distinct payment_mode
from sales

update sales 
set payment_mode='Credit card'
where payment_mode='CC'

select *from sales
--data analysis
--1:-what are the top 5 most selling products by quantity
select distinct status from sales
select top 5 product_name,sum(quantity)as total_quantity_sold
from sales 
where status='delivered'
group by product_name
order by total_quantity_sold desc;
--helps to prioritize stock and boost sales though target promotion
--2:-which product are most frequently canceled
select top 5 product_name,count(*)as total_canceled
from sales 
where status='cancelled'
group by product_name
order by total_canceled desc;--frequently cancelation affect revenue and customer trust,identity poor product to increase quality
--3:-what time of dayhas the highest number of purchase
select *from sales
select
case 
when datepart(hour,time_of_purchase)between 0 and 5 then 'night'
when datepart(hour,time_of_purchase)between 6 and 11 then 'morning'
when datepart(hour,time_of_purchase)between 12 and 17 then 'afternoon'
when datepart(hour,time_of_purchase)between 18 and 23 then 'evening'
end as time_of_day,
count(*) as total_order
from sales 
group by 
case
when datepart(hour,time_of_purchase)between 0 and 5 then 'night'
when datepart(hour,time_of_purchase)between 6 and 11 then 'morning'
when datepart(hour,time_of_purchase)between 12 and 17 then 'afternoon'
when datepart(hour,time_of_purchase)between 18 and 23 then 'evening'
end 
order by total_order desc;--optimize staffing,promotion,and server loads.
--4:-who are the top 5 highest spending customer

select top 5 customer_name,
format(sum(price*quantity),'C0','en-IN')as total_spend
from sales group by customer_name
order by sum(price*quantity) desc
--5:-which product category generate the highest revenue

select  product_category,
format(sum(price*quantity),'C0','en-IN') as Revenue 
from sales
group by product_category
order by sum(price*quantity)desc

--6:-what is the return/cancellation rate per category
--cancellation
select product_category,
format(count(case when status='cancelled'then 1 end)*100.0/count(*),'N3')+' %'
as canceled_percent
from sales
group by product_category
order by canceled_percent desc
--return
select product_category,
format(count(case when status='returned'then 1 end)*100.0/count(*),'N3')+' %'
as return_percent
from sales
group by product_category
order by return_percent desc

--7:-which is the most preferred payment mode
select payment_mode,count(payment_mode) as total_count
from sales
group by payment_mode
order by total_count desc

--8:-how does age group affect business behavior
select 
case 
when customer_age between 18 and 25 then '18-25'
when customer_age between 26 and 35 then '26-35'
when customer_age between 36 and 50 then '36-50'
else '51+'
end as customer_age,
format(sum(price*quantity),'C0','en-IN')as total_purchase
from sales
group by case 
when customer_age between 18 and 25 then '18-25'
when customer_age between 26 and 35 then '26-35'
when customer_age between 36 and 50 then '36-50'
else '51+'
end
order by sum(price*quantity) desc
--9:-what the monthly sales trend
--method 1
select format(purchase_date,'yyyy-MM')as month_year,
sum(price*quantity) as total_sales,
sum(quantity)as total_quantity
from sales
group by format(purchase_date,'yyyy-MM')
--method 2
select 
year(purchase_date)as years,
month(purchase_date)as month,
sum(price*quantity) as total_sales,
sum(quantity)as total_quantity
from sales
group by year(purchase_date),
month(purchase_date)
order by month
--are certain gender buying more specific product category
select gender,product_category,count(product_category)as total_purchase
from sales
group by gender,product_category
order by gender
--method 2
select *
from (
select gender,product_category
from sales)
as source_table
pivot
(count(gender) for gender in([M],[F])
)
as pivot_table
order by product_category










