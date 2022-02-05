create database exam ;
use exam;
select * from bank_account_details_ex;
select * from bank_account_transaction_ex;
select * from bank_customer_ex;
select * from orders_ex;
select * from salesman_ex;

create table customer
(
customer_id int(5),
cust_name varchar(10),
city varchar(10),
grade int,
salesman int
);

insert into exam.customer values (3002,'roshan', 'pune', 100, 5001);
insert into exam.customer values (3007,	'sameer','pune', 200, 5001);
insert into exam.customer values (3005,	'josh',	'mumbai', 200, 5002);
insert into exam.customer values (3008,	'ajeem', 'nagpu', 300, 5002);
insert into exam.customer values (3004,	'ravi', 'jaipur', 300, 5006);
insert into exam.customer values (3009,	'pooja', 'kolkata', 100, 5003);
insert into exam.customer values (3003,	'atul',	'banglore',	200, 5007);
insert into exam.customer values (3001,	'tom', 'delhi', 400, 5005);

select * from exam.customer;


-- 1. Write a SQL query which will sort out the customer and their grade
-- who made an order. Every customer must have a grade and be served
-- by at least one seller, who belongs to a region.

 select a.customer_id, a.cust_name, a.grade, c.salesman_id
from customer a, orders_ex b, salesman_ex c
where a.customer_id = b.customer_id
and b.salesman_id=c.salesman_id
and a.grade is not null
group by salesman having count(a.salesman)>=1;


-- 2. Write a query for extracting the data from the order table for the
-- salesman who earned the maximum commission.

select a.ord_no, a.purch_amt, a.ord_date, a.customer_id, b.*
from orders_ex a right join salesman_ex b 
on a.salesman_id = b.salesman_id
where b.commision = (select max(commision) from salesman_ex);
 

-- 3. From orders retrieve only ord_no, purch_amt, ord_date, ord_date,
-- salesman_id where salesman’s city is Nagpur(Note salesman_id of
-- orderstable must be other than the list within the IN operator.)

select a.ord_no, a.purch_amt, a.ord_date, a.salesman_id, b.city
from orders_ex a inner join salesman_ex b
on a.salesman_id = b.salesman_id
where city = 'nagpur';

select ord_no,purch_amt,ord_date,salesman_id
from exam.orders
where salesman_id not in 
(select salesman_id from exam.salesman
where city = 'Nagpur');

-- 4. Write a query to create a report with the order date in such a way
-- that the latest order date will come last along with the total purchase
-- amount and the total commission for that date is (15 % for all
-- sellers).

select ord_date, sum(purch_amt), sum(purch_amt*0.15) as total_commision from orders_ex group by ord_date order by ord_date ;

select ord_date,sum(purch_amt)as total from exam.orders
where salesman_id IN (select salesman_id from exam.salesman where commision=0.15)
group by ord_date
order by ord_date;

-- 5. Retrieve ord_no, purch_amt, ord_date, ord_date, salesman_id from
-- Orders table and display only those sellers whose purch_amt is
-- greater than average purch_amt.

select ord_no, purch_amt, ord_date, salesman_id from exam.orders_ex where purch_amt > (select avg(purch_amt) from orders_ex);

-- 6. Write a query to determine the Nth (Say N=5) highest purch_amt from
-- Orders table.

select purch_amt, round(purch_amt) from orders_ex order by round(purch_amt) desc limit 4,1; -- '1983.43'


-- 7. What are Entities and Relationships?

 -- ANS=
 -- ENTITIES = An entity is an object about which data is to be captured
 
 -- RELATIONSHIPS = Relationships between tables tell you how much of the data from a foreign key field can be seen in the related primary key column and vice versa. 
 
-- 8. Print customer_id, account_number and balance_amount, condition
-- that if balance_amount is nil then assign transaction_amount for
-- account_type = "Credit Card"

Select customer_id , a.account_number,
Case
   when ifnull(balance_amount,0) = 0 then  Transaction_amount 
   else balance_amount  
   end  as balance_amount
from Bank_Account_Details_ex a  
inner join
bank_account_transaction_ex b
on a.account_number = b.account_number
and account_type = "Credit Card";


-- 9. Print customer_id, account_number, balance_amount, conPrint
-- account_number, balance_amount, transaction_amount from
-- Bank_Account_Details and bank_account_transaction for all the
-- transactions occurred during march, 2020 and april, 2020.

select a.customer_id, a.account_number, a.Balance_amount, b.transaction_amount, b.transaction_date
from bank_account_details_ex a , bank_account_transaction_ex b
where a.account_number = b.account_number
and b.Transaction_Date between ('2020-03-01') and ('2020-04-30');

select distinct(b.transaction_date), a.Customer_id, a.Account_Number, a.Balance_amount, b.transaction_amount
from bank_account_details_ex a, bank_account_transaction_ex b
where transaction_date >= '2020-03-01' and transaction_date <= '2020-04-30'

-- 10. Print all of the customer id, account number, balance_amount,
-- transaction_amount from bank_cutomer, bank_account_details and
-- bank_account_transactions tables where excluding all of their
-- transactions in march, 2020 month .

select a.customer_id, a.account_number, a.Balance_amount, b.transaction_amount, b.transaction_date
from bank_account_details_ex a , bank_account_transaction_ex b, bank_customer_ex c
where a.account_number = b.account_number
and a.customer_id = c.customer_id
and b.Transaction_Date not like '2020-03-%'
