{% macro get_country_code(country_name) -%}
    {{ adapter.dispatch('get_country_code', 'census_utils') (country_name) }}
{%- endmacro %}

    {% macro default__get_country_code(country_name) -%}
    
        case when length({{ country_name }}) > 2 then (
            select country_code 
            from {{ ref('census_utils_country_codes') }} 
            where lower(country_name) =  lower({{ country_name }})
        ) else upper({{ country_name }}) end 
        
    {%- endmacro %}
