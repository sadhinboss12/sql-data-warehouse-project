/*
================================================================================
  CREATE DATABASE AND SCEMAS
================================================================================
*/

use master;
GO  
create database PracticeDataWareHouse;
GO
USE PracticeDataWareHouse
GO
create schema bronze;
go
create schema silver;
go
create schema gold;
GO
  /*
================================================================================
  CREATE TABLES IN DATABASE
================================================================================
*/
if object_id ('bronze.crm_cust_info','U') is not null
	drop table bronze.crm_cust_info;
create table bronze.crm_cust_info (
	cst_id int,
	cst_key nvarchar(50),
	cst_firstname nvarchar(50),
	cst_lastname nvarchar(50),
	cst_marital_status nvarchar(50),
	cst_gndr nvarchar(50),
	cst_create_date date
);
if object_id ('bronze.crm_prd_info','U') is not null
	drop table bronze.crm_prd_info;
create table bronze.crm_prd_info (
	prd_id int,
	prd_key nvarchar(50),
	prd_nm nvarchar(50),
	prd_cost int,
	prd_line nvarchar(50),
	prd_start_dt date,
	prd_end_dt date
);
if object_id ('bronze.crm_sales_details','U') is not null
	drop table bronze.crm_sales_details;
create table bronze.crm_sales_details (
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
if object_id ('bronze.erp_cust_az12','U') is not null
	drop table bronze.erp_cust_az12;
create table bronze.erp_cust_az12 (
	CID nvarchar(50),
	BDATE date,
	GEN nvarchar(50)
);
if object_id ('bronze.erp_cust_loce_info','U') is not null
	drop table bronze.erp_cust_loce_info;
create table bronze.erp_cust_loce_info (
	CID nvarchar(50),
	CNTRY nvarchar(50)
);
if object_id ('bronze.erp_px_cat_az12','U') is not null
	drop table bronze.erp_px_cat_az12;
create table bronze.erp_px_cat_az12 (
	id nvarchar(50),
	cat nvarchar(50),
	subcat nvarchar(60),
	maintenance nvarchar(50)
);
