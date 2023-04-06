{{ config(materialized="view") }}

with internal_users as (select * from {{ ref("census_users") }})

select 
    u.email_address
    , u.ip_address
    , {{ census_utils.is_internal(email='email_address',ip_address='ip_address') }} as is_internal_user
    , {{ census_utils.is_internal(email='email_address') }} as is_internal_email
    , {{ census_utils.is_internal(ip_address='ip_address') }} as is_internal_ip

from internal_users u