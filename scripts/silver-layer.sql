-- Insert data bronze layer to silver layer--
--Insert bronze.crm_cust_info to silver.crm_cust_info--
INSERT INTO silver.crm_cust_info (
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date 
)
SELECT
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
CASE 
	WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Maride'
	WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
	ELSE 'n/a'
END AS cst_marital_status,
CASE 
	WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
	WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
	ELSE 'n/a'
END AS cst_gndr,
cst_create_date
FROM (
select
* ,
ROW_NUMBER() over (partition by cst_id order by cst_create_date desc) as flag_last
from bronze.crm_cust_info
)t WHERE flag_last = 1;
--Insert bronze.crm_prd_info to silver.crm_prd_info--
INSERT INTO silver.crm_prd_info(
	prd_id,
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
)

SELECT
prd_id,
REPLACE(SUBSTRING(prd_key,1,5),'-','_') as cat_id,
SUBSTRING(prd_key,7,LEN(prd_key)) as prd_key,
prd_nm,
ISNULL(prd_cost,0) AS prd_cost,
CASE 
	WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
	WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
	WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
	WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
	ELSE 'n/a'
END AS prd_line,
CAST(prd_start_dt AS DATE) AS prd_start_dt,
CAST(LEAD(prd_start_dt) over (PARTITION BY prd_key ORDER BY prd_start_dt ) - 1 AS DATE) as prd_end_dt

FROM bronze.crm_prd_info

--Insert bronze.crm_sales_details to silver.crm_sales_details--

INSERT INTO silver.crm_sales_details (
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
)

SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	CASE
		WHEN LEN(sls_order_dt) < 8 THEN NULL
		ELSE CAST(CAST(sls_order_dt AS NVARCHAR) AS DATE)
		END AS sls_order_dt,
	CASE
		WHEN LEN(sls_ship_dt) < 8 THEN NULL
		ELSE CAST(CAST(sls_ship_dt AS NVARCHAR) AS DATE)
		END AS sls_ship_dt,
	CASE
		WHEN LEN(sls_due_dt) < 8 THEN NULL
		ELSE CAST(CAST(sls_due_dt AS NVARCHAR) AS DATE)
		END AS sls_due_dt,
	CASE 
	WHEN sls_sales is null or sls_sales != sls_quantity * sls_price or sls_sales <= 0 THEN sls_quantity * ABS(sls_price)
	ELSE sls_sales
END sls_sales,
sls_quantity,
CASE 
	WHEN sls_price is null or sls_price <= 0   THEN sls_sales /  NULLIF(sls_quantity,0)
	ELSE sls_price
END sls_price
FROM bronze.crm_sales_details

--Insert bronze.erp_cust_az12 to silver.erp_cust_az12--

INSERT INTO silver.erp_cust_az12 (
	cid,
	bdate,
	gen
)
select
case
    when cid like 'NAS%' then substring(cid,4,len(cid))
	else cid
end cid,
case 
	when bdate > getdate() then null
	else bdate
end bdate,
 case
	when gen is null or gen = '' then 'n/a'
	when gen = 'M' then 'Male'
	when gen = 'F' then 'Female'
	else gen
end gen
from bronze.erp_cust_az12

--Insert bronze.erp_cust_loce_info to silver.erp_cust_loce_info--
insert into silver.erp_cust_loce_info (
	cid,
	cntry
)
select
replace(cid,'-','') cid,
case
	when trim(cntry) in ('US','USA') then 'United States'
	when trim(cntry) = 'DE' then 'Germany'
	when trim(cntry) = ''or cntry is null then 'n/a'
	else trim (cntry)
end cntry
from bronze.erp_cust_loce_info

--Insert bronze.erp_px_cat_az12 to silver.erp_px_cat_az12--
insert into silver.erp_px_cat_az12 (
id,
cat,
subcat,
maintenance
)
select 
id,
cat,
subcat,
maintenance
from bronze.erp_px_cat_az12
