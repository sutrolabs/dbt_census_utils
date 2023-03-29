{{ config(materialized="view") }}

with internal_users as (select * from {{ ref("census_internal_users") }})

select 
    u.email_address
    , u.ip_address
    , {{ census_utils.is_internal(email='email_address',ip_address='ip_address') }} as is_internal_user
from internal_users u