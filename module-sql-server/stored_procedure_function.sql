--Write a function to calculate the sum of two numbers a and b
CREATE FUNCTION total_a_b
( @a int, @b int) 
returns int 
as begin
declare @sum int;
set @sum = @a+@b;
return @sum;
end 

-- Write a function to calculate the sum from 1 to n
CREATE FUNCTION sum_1_to_n
(  @n int) 
returns int 
as begin
declare @sum int =0;
declare @i int =1;
while @i <= @n
begin 
	set @sum = @sum + @i
	set @i = @i +1;
end ;
return @sum
end

/* Write a function to calculate the payment for an order_item

Name: fcn_order_item_payment

Input: order_id, item_id

Output: item price */

create function fcn_order_item_payment 
( @order_id int, @item_id int) 
returns decimal(18,2)
as begin
declare @item_price decimal(18,2);
select @item_price = quantity * list_price
from [sales].[order_items]
where order_id = @order_id  and  item_id = @item_id;
RETURN ISNULL(@item_price, 0);
END;
--test
select dbo.fcn_order_item_payment(1,2) as 

/*
Write a function to calculate the payment for an order

Name: fcn_order_total_payment

Input: order_id

Output: order price */
create function fcn_order_total_payment 
( @order_id int) 
returns decimal(18,2)
as begin
declare @item_price decimal(18,2);
select @item_price = quantity * list_price
from [sales].[order_items]
where order_id = @order_id  and  item_id = @item_id;
RETURN ISNULL(@item_price, 0);
END;


select * from [sales].[order_items]