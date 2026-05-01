-- Q1: Count transactions by status
select status, count(*) as count from transactions group by status;

-- Q2: Calculate total captured GMV by merchant
select merchant_name, sum(raw_amount) as total_GMV, sum(raw_amount_USD) as total_GMV_USD from transactions 
where status='Captured' group by merchant_name order by merchant_name asc;

-- Q3: Show top 10 merchants by captured GMV
select merchant_name, sum(raw_amount) as total_GMV from transactions where status='Captured' 
group by merchant_name order by total_GMV desc limit 10;

-- Q4: Show daily GMV and successful transaction count
select transaction_date, sum(raw_amount) as daily_GMV, count(transaction_id) as count_successful from transactions 
where status='Captured' group by transaction_date;

-- Q5: Find merchants with chargeback ratio above 1%
with chargeback as (select merchant_name, count(transaction_id) as chargeback_count from transactions 
where status='Chargeback' group by merchant_name)
select txn.merchant_name, COALESCE(cb.chargeback_count, 0) / COUNT(txn.transaction_id) * 100 as chargeback_ratio 
from transactions txn left join chargeback cb on cb.merchant_name = txn.merchant_name 
group by txn.merchant_name, cb.chargeback_count having chargeback_ratio > 1 order by chargeback_ratio desc;

-- Q6: Find regions with average risk score above 50 and more than 20 transactions
select gateway_region as region, avg(risk_score), count(transaction_id) from transactions 
group by gateway_region having avg(risk_score) > 50 and count(transaction_id) > 20

-- Q7: Find users with 3 or more failed or chargeback transactions on the same day
select txn.user_id, users.user_name, transaction_date, count(transaction_id) 
from transactions txn left join users on txn.user_id = users.user_id
where status in ('Chargeback', 'Failed E05 Timeout') group by user_id, transaction_date having count(transaction_id) > 3;

-- Q8: Show chargeback count, unique affected users, and chargeback amount by merchant
select merchant_name, count(distinct user_id) as unique_affected_users, count(transaction_id) as chargeback_count, 
sum(raw_amount) as chargeback_amount from transactions where status = 'Chargeback' group by merchant_name
