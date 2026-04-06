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

/*
Write a function to return the day of the week for a given date

Name: fcn_DOW

Input: date

Output: Monday → 2 … Sunday → 1
*/

CREATE FUNCTION fcn_DOW
( @date date)
returns int 
as begin
declare @dow int;
set @dow = datepart(dw, @date);
return @dow;
end 

/* Write a procedure to create an order

-- write a procedure to create an order:

-- sales.orders:

-- order_id: auto-increment

-- customer_id: randomly selected from the sales.customers table

-- order_status: default to 4

-- order_date: randomly add 0 to 30 days to the current date

-- required_date: randomly within order_date + 20 days

-- shipped_date: randomly within required_date + 15 days

-- store_id: randomly selected from the sales.stores table

-- staff_id: randomly selected from the sales.staffs table

-- sales.order_items: random number of lines from 3 to 15

-- order_id: the order_id created above

-- item_id: incrementing based on the number of items in this order

-- product_id: randomly selected from the production.products table

-- quantity: randomly between 1 and 12

-- list_price: the price of the selected product

-- discount: randomly from these values: 0, 5%, 10%, 15%, 20% */
create procedure sales.usp_CreateRandomOrder
as 
begin 
set nocount on 
begin try
begin transaction
declare @new_order_id int
declare @customer_id int 
declare @order_date date
declare @required_date date 
declare @shipped_date date 
declare @store_id int 
declare @staff_id int

select top 1 @customer_id = customer_id from sales.customers order by newid()
select top 1 @store_id = store_id from sales.stores order by newid()
select top 1 @staff_id = staff_id from sales.staffs order by newid()
SET @order_date = DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 31, GETDATE());
SET @required_date = DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 21, @order_date);
SET @shipped_date = DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 16, @required_date);
INSERT INTO sales.orders (
            customer_id, order_status, order_date, required_date, shipped_date, store_id, staff_id
        )
        VALUES (
            @customer_id, 4, @order_date, @required_date, @shipped_date, @store_id, @staff_id
        );
SET @new_order_id = SCOPE_IDENTITY();

DECLARE @total_items INT = (ABS(CHECKSUM(NEWID())) % 13) + 3;
DECLARE @current_item_id INT = 1;
DECLARE @product_id INT;
DECLARE @list_price DECIMAL(18, 2);
DECLARE @quantity INT;
DECLARE @discount DECIMAL(4, 2);
WHILE @current_item_id <= @total_items
        BEGIN
            SELECT TOP 1 
                @product_id = product_id, 
                @list_price = list_price
            FROM production.products
            ORDER BY NEWID();
SET @quantity = (ABS(CHECKSUM(NEWID())) % 12) + 1;

            SET @discount = (ABS(CHECKSUM(NEWID())) % 5) * 0.05;

            INSERT INTO sales.order_items (
                order_id, item_id, product_id, quantity, list_price, discount
            )
            VALUES (
                @new_order_id, @current_item_id, @product_id, @quantity, @list_price, @discount
            );

            SET @current_item_id = @current_item_id + 1;
        END

        COMMIT TRANSACTION;
        
        PRINT 'Successfully created Order ID: ' + CAST(@new_order_id AS VARCHAR(10)) + ' with ' + CAST(@total_items AS VARCHAR(10)) + ' items.';

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        PRINT 'Error creating order: ' + @ErrorMessage;
    END CATCH
END;
GO

/* 
Write a function to count the number of order_items in an order

Input: order_id

Output: number_of_item
*/ 


create function count_number_item
( @order_id int) 
returns int
as begin
declare @number_of_item int;
select @number_of_item = count(item_id)
from [sales].[order_items]
where order_id = @order_id 
RETURN ISNULL(@number_of_item, 0);
END;
--test
select dbo.count_number_item(15)
/*
Write a function to get the latest order_id
*/
create function latest_order_id()
returns int
as begin
declare @last int;
select @last = max(order_id)
from [sales].[orders]
RETURN ISNULL(@last, 0);
END;
--test
select dbo.latest_order_id()