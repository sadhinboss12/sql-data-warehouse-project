create or alter procedure bronze.load_bronze as 
begin
	-- CRM TABLES DATA INSERTING
	
	truncate table bronze.crm_cust_info;

	bulk insert bronze.crm_cust_info
	from 'C:\All data for prectice\New folder\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
	with(
		firstrow = 2,
		fieldterminator = ',',
		tablock
	);


	truncate table bronze.crm_prd_info;

	bulk insert bronze.crm_prd_info
	from 'C:\All data for prectice\New folder\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
	with(
		firstrow = 2,
		fieldterminator = ',',
		tablock
	);

	truncate table bronze.crm_sales_details;

	bulk insert bronze.crm_sales_details
	from 'C:\All data for prectice\New folder\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
	with(
		firstrow = 2,
		fieldterminator = ',',
		tablock
    );
	-- ERP TABLES DATA INSERTING
	truncate table bronze.erp_cust_az12;
	bulk insert bronze.erp_cust_az12
	from 'C:\All data for prectice\New folder\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
	with(
		firstrow = 2,
		fieldterminator = ',',
		tablock
	);

	truncate table bronze.erp_cust_loce_info;

	bulk insert bronze.erp_cust_loce_info
	from 'C:\All data for prectice\New folder\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
	with(
		firstrow = 2,
		fieldterminator = ',',
		tablock
	);

	truncate table bronze.erp_px_cat_az12;

	bulk insert bronze.erp_px_cat_az12
	from 'C:\All data for prectice\New folder\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
	with(
		firstrow = 2,
		fieldterminator = ',',
		tablock
	);

end
/*
================================================================================
  CREATE SILVER LAYER TABLE IN DATABASE 
================================================================================
*/
use PracticeDataWareHouse
if object_id ('silver.crm_cust_info','U') is not null
	drop table silver.crm_cust_info;
create table silver.crm_cust_info (
	cst_id int,
	cst_key nvarchar(50),
	cst_firstname nvarchar(50),
	cst_lastname nvarchar(50),
	cst_marital_status nvarchar(50),
	cst_gndr nvarchar(50),
	cst_create_date date
);
if object_id ('silver.crm_prd_info','U') is not null
	drop table silver.crm_prd_info;
create table silver.crm_prd_info (
	prd_id int,
	prd_key nvarchar(50),
	prd_nm nvarchar(50),
	prd_cost int,
	prd_line nvarchar(50),
	prd_start_dt date,
	prd_end_dt date
);
if object_id ('silver.crm_sales_details','U') is not null
	drop table silver.crm_sales_details;
create table silver.crm_sales_details (
	sls_ord_num nvarchar(50),
	sls_prd_key nvarchar(50),
	sls_cust_id int,
	sls_order_dt int,
	sls_ship_dt int,
	sls_due_dt int,
	sls_sales int,
	sls_quantity int,
	sls_price int
);
--erp starts here 
if object_id ('silver.erp_cust_az12','U') is not null
	drop table silver.erp_cust_az12;
create table silver.erp_cust_az12 (
	CID nvarchar(50),
	BDATE date,
	GEN nvarchar(50)
);
if object_id ('silver.erp_cust_loce_info','U') is not null
	drop table silver.erp_cust_loce_info;
create table silver.erp_cust_loce_info (
	CID nvarchar(50),
	CNTRY nvarchar(50)
);
if object_id ('silver.erp_px_cat_az12','U') is not null
	drop table silver.erp_px_cat_az12;
create table silver.erp_px_cat_az12 (
	id nvarchar(50),
	cat nvarchar(50),
	subcat nvarchar(60),
	maintenance nvarchar(50)
);
