{{ config(materialized="view") }}

with country_name as (select * from {{ ref("census_utils_country_names_to_map") }})

select 
    c.country_name,
    {{ census_utils.get_country_code('c.country_name') }} as country_code
from country_name c