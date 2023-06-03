{% macro extract_email_domain(email) -%}
    {{ adapter.dispatch('extract_email_domain', 'census_utils') (email) }}
{%- endmacro %}

    {% macro default__extract_email_domain(email) -%}
        case when contains_substr(regexp_substr(lower(replace(rtrim({{ email }},'.'),' ','')), '@(.*)', 1, 1),'.') = true 
            then regexp_substr(lower(replace(rtrim({{ email }},'.'),' ','')), '@(.*)', 1, 1)
        end
    {%- endmacro %}

    {%- macro snowflake__extract_email_domain(email) %}
        case when contains(regexp_substr(lower(replace(rtrim({{ email }},'.'),' ','')), '@(.*)', 1, 1, 'e',1),'.') = true  
            then regexp_substr(lower(replace(rtrim({{ email }},'.'),' ','')), '@(.*)', 1, 1, 'e',1)
        end
    {%- endmacro -%}

    {%- macro redshift__extract_email_domain(email) %}
        case when regexp_instr(regexp_substr(lower(replace(rtrim({{ email }},'.'),' ','')), '@(.*)', 1, 1),'\\.') > 0
            then regexp_substr(lower(replace(rtrim({{ email }},'.'),' ','')), '@(.*)', 1, 1, 'e')
        end
    {%- endmacro -%}

