{% macro is_personal_email(email) -%}
    {{ adapter.dispatch('is_personal_email', 'census_utils') (email) }}
{%- endmacro %}

    {% macro default__is_personal_email(email) -%}
    
        {%- set free_email_providers = dbt_utils.get_column_values(table=ref('free_email_providers'), column='email_domains') -%}
        
        case when regexp_substr(lower(replace(rtrim({{ email }},'.'),' ','')), '@(.*)', 1, 1) in unnest({{ free_email_providers }}) then true else false end

    {%- endmacro %}

    {% macro snowflake__is_personal_email(email) -%}
    
        {%- set free_email_providers = dbt_utils.get_column_values(table=ref('free_email_providers'), column='email_domains') -%}
        
        array_contains(regexp_substr(lower(replace(rtrim({{ email }},'.'),' ')), '@(.*)', 1, 1, 'e',1)::variant,{{free_email_providers}})

    {%- endmacro %}