# SQL Answers

## Q1
Count transactions by status
### Query
select status, count(*) as count from transactions group by status;
### Result Summary
| status	        | count |
-----------------   | ----  |
| Captured          | 19    | 
| Chargeback	    | 4     | 
| Failed E05 Timeout| 7     |

## Q2
Calculate total captured GMV by merchant
### Query
select merchant_name, sum(raw_amount) as total_GMV, sum(raw_amount_USD) as total_GMV_USD from transactions 
where status='Captured' group by merchant_name order by merchant_name asc;
### Result Summary
| merchant_name | total_GMV | total_GMV_USD |
| ------------- | --------- | ------------- |
| Alpha Mart    | 2515000.0 | 29984.5       |
| Beta Stores   | 2785000.0 | 33431.0       |
| City Pharma   | 8000.0    | 8640.0        |
| Delta Travels | 10300.0   | 10300.0       |

## Q3
Show top 10 merchants by captured GMV
### Query
select merchant_name, sum(raw_amount) as total_GMV from transactions where status='Captured' 
group by merchant_name order by total_GMV desc limit 10;
### Result Summary
| merchant_name | total_GMV |
| ------------- | --------- |
| Beta Stores   | 2785000.0 |
| Alpha Mart    | 2515000.0 |
| Delta Travels | 10300.0   |
| City Pharma   | 8000.0    |


## Q4
Show daily GMV and successful transaction count
### Query
select transaction_date, sum(raw_amount) as daily_GMV, count(transaction_id) as count_successful from transactions 
where status='Captured' group by transaction_date;
### Result Summary
| transaction_date | daily_GMV | count_successful |
| ---------------- | --------- | ---------------- |
| 2026_03-01       | 1152400.0 | 5                |
| 2026_03-02       | 668100.0  | 3                |
| 2026_03-03       | 1077800.0 | 4                |
| 2026_03-04       | 1160000.0 | 4                |
| 2026_03-05       | 520000.0  | 1                |
| 2026_03-06       | 740000.0  | 2                |

## Q5
Find merchants with chargeback ratio above 1%
### Query
with chargeback as (select merchant_name, count(transaction_id) as chargeback_count from transactions 
where status='Chargeback' group by merchant_name)
select txn.merchant_name, COALESCE(cb.chargeback_count, 0) / COUNT(txn.transaction_id) * 100 as chargeback_ratio 
from transactions txn left join chargeback cb on cb.merchant_name = txn.merchant_name 
group by txn.merchant_name, cb.chargeback_count having chargeback_ratio > 1 order by chargeback_ratio desc;
### Result Summary
| merchant_name | chargeback_ratio |
| ------------- | ---------------- |
| Eco Home      | 50.0             |
| Delta Travels | 25.0             |
| Alpha Mart    | 9.0909           |
| Beta Stores   | 9.0909           |

## Q6
Find regions with average risk score above 50 and more than 20 transactions
### Query
select gateway_region as region, avg(risk_score), count(transaction_id) from transactions 
group by gateway_region having avg(risk_score) > 50 and count(transaction_id) > 20
### Result Summary
| region | avg(risk_score) | count(transaction_id) |
| ------ | --------------- | --------------------- |
| APAC   | 62.5            | 22                    |

## Q7
Find users with 3 or more failed or chargeback transactions on the same day
### Query
select txn.user_id, users.user_name, transaction_date, count(transaction_id) 
from transactions txn left join users on txn.user_id = users.user_id
where status in ('Chargeback', 'Failed E05 Timeout') group by user_id, transaction_date having count(transaction_id) > 3;
### Result Summary
| user_id | user_name    | transaction_date | count(transaction_id) |
| ------- | ------------ | ---------------- | --------------------- |
| U008    | Ishaan Verma | 2026_03-05       | 4                     |

## Q8
Show chargeback count, unique affected users, and chargeback amount by merchant
### Query
select merchant_name, count(distinct user_id) as unique_affected_users, count(transaction_id) as chargeback_count, 
sum(raw_amount) as chargeback_amount from transactions where status = 'Chargeback' group by merchant_name
### Result Summary
| merchant_name | unique_affected_users | chargeback_count | chargeback_amount |
| ------------- | --------------------- | ---------------- | ----------------- |
| Alpha Mart    | 1                     | 1                | 450000.0          |
| Beta Stores   | 1                     | 1                | 145000.0          |
| Delta Travels | 1                     | 1                | 2500.0            |
| Eco Home      | 1                     | 1                | 6100.0            |
