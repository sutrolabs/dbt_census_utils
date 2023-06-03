{% macro is_personal_email(email,treat_null_as_false=false) -%}
    {{ adapter.dispatch('is_personal_email', 'census_utils') (email,treat_null_as_false) }}
{%- endmacro %}

    {% macro default__is_personal_email(email,treat_null_as_false) -%}
    
        case 
            when {{ census_utils.extract_email_domain(email)}} is null and {{treat_null_as_false}} = false then null 
            when (select {{ dbt.any_value(1) }} from {{ ref('census_utils_free_email_providers') }} where {{ census_utils.extract_email_domain(email)}} = email_domains) = 1 then true
            else false
        end

    {%- endmacro %}
