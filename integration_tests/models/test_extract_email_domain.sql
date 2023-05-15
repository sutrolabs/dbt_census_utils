{{ config(materialized="view") }}

with email_addresses as (select * from {{ ref("census_utils_email_addresses") }})

select 
    n.email_addresses,
    {{ census_utils.extract_email_domain('n.email_addresses') }} as email_domain
from email_addresses n