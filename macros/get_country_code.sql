{% macro get_country_code(country_name) -%}
    {{ adapter.dispatch('get_country_code', 'census_utils') (country_name) }}
{%- endmacro %}

    {% macro default__get_country_code(email) -%}
    
        {% set sql_statement %}
            select country_name, country_code from  {{ref('country_codes') }}
        {% endset %}

        {%- set country_code_mapping = dbt_utils.get_query_results_as_dict(sql_statement) -%}
        
        case
        {% for cname in country_code_mapping['country_name'] -%}
            when lower(country_name) = lower('{{cname | replace("'", "\\'")}}') then '{{country_code_mapping["country_code"][loop.index0 ]}}'
        {% endfor %}
            when length(country_name) = 2 then upper(country_name)
        end
    {%- endmacro %}