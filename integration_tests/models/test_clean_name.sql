{{ config(materialized="view") }}

with names as (select * from {{ ref("census_names_to_clean") }})

select 
    {{ census_utils.clean_name(name, 'facebook') }} as name
from names n
