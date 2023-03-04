{{ config(materialized="table") }}

with names as (select * from {{ ref("census_names") }})

select n.name
, {{ clean_name(name, 'facebook') }} as facebook_name
from names n
