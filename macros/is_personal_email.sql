{% macro is_personal_email(email) -%}
    {{ adapter.dispatch('is_personal_email', 'census_utils') (email) }}
{%- endmacro %}

    {% macro default__is_personal_email(email) -%}
    
        {%- set free_email_providers = dbt_utils.get_column_values(table=ref('census_utils_free_email_providers'), column='email_domains') -%}
        
        case when {{ census_utils.extract_email_domain(email) }} in unnest({{ free_email_providers }}) then true else false end

    {%- endmacro %}

    {% macro snowflake__is_personal_email(email) -%}
    
        {%- set free_email_providers = dbt_utils.get_column_values(table=ref('census_utils_free_email_providers'), column='email_domains') -%}
        
        array_contains({{ census_utils.extract_email_domain(email) }}::variant,{{free_email_providers}})

    {%- endmacro %}

    {% macro redshift__is_personal_email(email) -%}
    
        {%- set free_email_providers = dbt_utils.get_column_values(table=ref('census_utils_free_email_providers'), column='email_domains')|join(',') -%}

        case when charindex({{ census_utils.extract_email_domain(email) }},'{{free_email_providers}}') > 0 then true else false end

    {%- endmacro %}