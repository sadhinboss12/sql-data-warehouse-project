create view gold.dim_customers as
select
row_number() over (order by cf.cst_id) as customer_key,
cf.cst_id as customer_id,
cf.cst_key as customer_number,
cf.cst_firstname as first_name,
cf.cst_lastname as last_name,
cl.CNTRY as country,
cf.cst_marital_status as marital_status,
case
	when cf.cst_gndr != 'n/a' then cf.cst_gndr
	else coalesce(ca.GEN,'n/a')
end gender,
cf.cst_create_date as create_date,
ca.BDATE as birth_date
from silver.crm_cust_info cf
left join silver.erp_cust_az12 ca
on cf.cst_key = ca.CID
left join silver.erp_cust_loce_info cl
on cf.cst_key = cl.CID
where cf.cst_id is not null

create view gold.dim_products as
select
ROW_NUMBER() over (order by pn.prd_start_dt,pn.prd_key) as product_key,
pn.prd_id as product_id,
pn.prd_key as product_number,
pn.prd_nm as product_name,
pn.cat_id as category_id,
pc.cat as catagory,
pc.subcat as sub_category,
pc.maintenance as maintenance,
pn.prd_line as product_line,
pn.prd_cost as product_cost,
pn.prd_start_dt as start_date
from silver.crm_prd_info pn
left join silver.erp_px_cat_az12 pc
on pn.cat_id = pc.id
where prd_end_dt is null

create view gold.fact_sales as
select
sd.sls_ord_num as order_number,
p.product_key,
c.customer_key,
sd.sls_order_dt as order_date,
sd.sls_ship_dt as shiping_date,
sd.sls_due_dt as due_date,
sd.sls_sales as sales_amount,
sd.sls_quantity as quantity,
sd.sls_price as price
from silver.crm_sales_details sd
left join gold.dim_customers c
on sd.sls_cust_id = c.customer_id
left join gold.dim_products p
on sd.sls_prd_key = p.product_number
