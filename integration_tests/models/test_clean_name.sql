{{ config(materialized="view") }}

with names as (select * from {{ ref("census_names_to_clean") }})

select 
    {{ census_utils.clean_name(name, 'facebook') }} as facebook_name,
    {{ census_utils.clean_name(name, 'google') }} as google_name,
    {{ census_utils.clean_name(name) }} as default_name

from names n
