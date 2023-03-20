{{ config(materialized="view") }}

with ga4_client as (select * from {{ ref("ga4_client_id") }})

select 
    ga4_client_id,
    {{ census_utils.parse_ga4_client_id('ga4_client_id', 'unique_id') }} as unique_id,
    {{ census_utils.parse_ga4_client_id('ga4_client_id', 'timestamp') }} as timestamp,
    {{ census_utils.parse_ga4_client_id('ga4_client_id', 'client_id') }} as client_id,
    {{ census_utils.parse_ga4_client_id('ga4_client_id') }} as test
from ga4_client