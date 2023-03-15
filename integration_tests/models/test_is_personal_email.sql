{{ config(materialized="table") }}

with email_addresses as (select * from {{ ref("census_email_addresses") }})

select 
    n.email_addresses,
    {{ census_utils.is_personal_email('n.email_addresses') }} as is_personal_email
from email_addresses n