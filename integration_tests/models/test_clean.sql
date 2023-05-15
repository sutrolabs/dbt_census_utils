{{ config(materialized="view") }}

with names as (select * from {{ ref("census_utils_fields_to_clean") }})

select 
    {{ census_utils.clean('fn_to_clean',type='name',destination='facebook') }} as cleaned_facebook_fn,
    {{ census_utils.clean('ln_to_clean',destination='facebook') }} as cleaned_facebook_ln,
    {{ census_utils.clean('city_to_clean',destination='facebook',type='city') }} as cleaned_facebook_city,
    {{ census_utils.clean('city_to_clean',destination='google',type='city') }} as cleaned_google_city,
    {{ census_utils.clean('zip_to_clean',type='zip', destination='facebook') }} as cleaned_facebook_zip,
    {{ census_utils.clean('zip_to_clean',type='zip', destination='google') }} as cleaned_google_zip,
    {{ census_utils.clean('fn_to_clean','google') }} as cleaned_google_fn,
    {{ census_utils.clean('email_to_clean','facebook','email') }} as cleaned_facebook_email,
    {{ census_utils.clean('email_to_clean','google','email') }} as cleaned_google_email,
    {{ census_utils.clean('country_to_clean','google','country') }} as cleaned_google_country,
    {{ census_utils.clean('country_to_clean','facebook','country') }} as cleaned_facebook_country,
    {{ census_utils.clean('fn_to_clean') }} as default_clean

from names n
