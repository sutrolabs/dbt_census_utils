{{ config(materialized="table") }}

with email as (select * from {{ ref("email") }})

select 
    n.email,
    {{ extract_email_domain('n.email') }} as email_domain
from email n
