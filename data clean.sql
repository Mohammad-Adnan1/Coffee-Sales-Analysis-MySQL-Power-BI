create database coffee_shop_sales_db;
use coffee_shop_sales_db;
select * from coffee_shop_sales;

describe coffee_shop_sales;

update coffee_shop_sales
set transaction_date = str_to_date(transaction_date,'%m/%d/%Y');

alter table coffee_shop_sales 
modify column transaction_date date;


alter table coffee_shop_sales
modify column transaction_id int;

alter table coffee_shop_sales
modify column store_id int;

alter table coffee_shop_sales
modify column product_id int;

alter table coffee_shop_sales
modify column transaction_qty int;

update coffee_shop_sales
set transaction_time = str_to_date(transaction_time,'%H:%i:%s');

alter table coffee_shop_sales 
modify column transaction_time time;




