{{ config(materialized="view") }}

with names as (select * from {{ ref("census_names_to_clean") }})

select 
    {{ census_utils.clean_name('name_to_clean', 'facebook') }} as facebook_name,
    {{ census_utils.clean_name('name_to_clean', 'google') }} as google_name,
    {{ census_utils.clean_name('name_to_clean') }} as default_name

from names n
