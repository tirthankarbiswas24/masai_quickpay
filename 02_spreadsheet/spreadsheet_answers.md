# Spreadsheet Answers

## Cleaning Steps
- **Date**: Used the formula *=TEXT(if(or(B2="", B2="UNKNOWN", B2="ERROR"), "1900-01-01", B2), "YYYY-MM-DD")*
- **Merchant Name**: Used the formuala *=trim(if(OR(D2="", D2="ERROR", D2="UNKNOWN"), "INVALID_OR_MISSING", proper(D2)))*
- **Status**: Used the formula *=if(OR(J2="",J2 ="ERROR",J2 ="UNKNOWN"), "INVALID_OR_MISSING", proper(J2))*
- **risk_score**: Used the formula *=if(OR(L2="",L2 ="ERROR",L2 ="UNKNOWN"), "INVALID_OR_MISSING", value(RIGHT(L2, 2)))*
- **gateway_region**: Used the formula *=Filter(merchant_master!$E$2:$E$6,E2=merchant_master!$B$2:$B$6)*

## Standardization Rules
- **convert transaction amounts** into a single reporting currency: Converted the curreny rate to USD for the given currency and date pair by looking up the conversion rate from exchange_rate file. Used the formula *=filter(exchange_rates!$C$2:C$19,B2=exchange_rates!$A$2:$A$19, I2=exchange_rates!$B$2:$B$19)*
Using this currency rate all amounts were converted to USD by multiplying the raw_amount with the currency rate.
- **Converted Merchant Name** to a standard format using trim and proper function in google sheet
- **Converted risk_score** to a standard number format by collecting the last 2 digits
- **Convert status** to a standard format using trim and proper function in google sheet

## Lookup and Enrichment Logic
- **Currency conversion rate**: We converted all amounts to USD amount. It was done in 2 steps. First we looked up the exchange rate for the given currency and transaction date in the exchange_rates sheet and used the usd_rate value. We multiplied the raw amount with this usd_rate to the amount in USD.  

- **gateway_region**: Using standardized merchant name in transactions_raw sheet we looked up for the default_region from the merchant_master sheet and used it in transactions_raw sheet. Used the formula *=Filter(merchant_master!$E$2:$E$6,E2=merchant_master!$B$2:$B$6)*

## Final Answers

- Total raw rows: 30
- Total cleaned rows: 30
- Invalid or missing rows handled: 1 (Txn T011 did not have risk_score value)
- Top region by GMV: **APAC** region had total GMV **82594 USD / 6910000 INR** (Pivot table added in the spreadsheet_workbook - PivotTables sheet)
- Number of high value transactions: **7** (Used sum of values for the column high_value_flag)
- Number of high risk transactions: **9** (Used sum of values for the column high_risk_flag)
- Top merchant by captured GMV: **Beta Stores**	had the maximum GMV **33431 USD / 2785000 INR**  (Pivot table added in the spreadsheet_workbook - PivotTables sheet)

## Formula Samples
- **Date Cleaning** : *=TEXT(if(or(B2="", B2="UNKNOWN", B2="ERROR"), "1900-01-01", B2), "YYYY_MM-DD")*
- **Merchant Name Cleaning**: *=trim(if(OR(D2="", D2="ERROR", D2="UNKNOWN"), "INVALID_OR_MISSING", proper(D2)))*
- **Status Cleaning**: *=if(OR(J2="",J2 ="ERROR",J2 ="UNKNOWN"), "INVALID_OR_MISSING", proper(J2))*
- **risk_score Cleaning**: *=if(OR(L2="",L2 ="ERROR",L2 ="UNKNOWN"), "INVALID_OR_MISSING", value(RIGHT(L2, 2)))*
- **gateway_region cleaning**: *=Filter(merchant_master!$E$2:$E$6,E2=merchant_master!$B$2:$B$6)*
- **Fetching Exchange Rates**: *=filter(exchange_rates!$C$2:C$19,B2=exchange_rates!$A$2:$A$19, I2=exchange_rates!$B$2:$B$19)*