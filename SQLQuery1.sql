create database vrindasales;
use vrindasales;
/*total sales*/
select sum(amount) as total_sales from [dbo].[Vrinda Store Data Analysis (1)];
/*sales by category*/
select Category ,sum(amount) as total_sales
from [dbo].[Vrinda Store Data Analysis (1)]
group by Category 
order by total_sales desc;
/*total orders*/
select count(DISTINCT [Order_ID])as total_orders from [dbo].[Vrinda Store Data Analysis (1)];
/*Total customers*/
select count(distinct [Cust_ID]) as total_customers from [dbo].[Vrinda Store Data Analysis (1)];
/*sales by state*/
select [ship_state], sum(amount) as total_sales 
from [dbo].[Vrinda Store Data Analysis (1)] group by[ship_state]
order by total_sales desc;
/*order by channel*/
select channel, sum(amount) as total_sales
from [dbo].[Vrinda Store Data Analysis (1)]
group by channel
order by total_sales desc;
/* top 10 customers*/
select top 10
[Cust_ID],sum(amount) as total_sales from [dbo].[Vrinda Store Data Analysis (1)]
group by [Cust_ID]
order by total_sales desc;
/* top 5 products*/
select top 5 SKU ,sum(amount)as total_sales
from [dbo].[Vrinda Store Data Analysis (1)]
group by SKU
order by total_sales desc;

