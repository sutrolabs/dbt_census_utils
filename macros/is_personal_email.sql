{% macro is_personal_email(email) -%}
    {{ adapter.dispatch('is_personal_email', 'census_utils') (email) }}
{%- endmacro %}

    {% macro default__is_personal_email(email) -%}
    
        {% set sql_statement %}
            select array_agg(email_domains) email_domains from {{ref('free_email_providers') }}
        {% endset %}

        {%- set free_email_providers = dbt_utils.get_single_value(sql_statement) -%}
        
        case when regexp_substr(lower(replace(rtrim({{ email }},'.'),' ','')), '@(.*)', 1, 1) in unnest({{ free_email_providers }}) then true else false end

    {%- endmacro %}