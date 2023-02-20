{% macro extract_email_domain(email) -%}
    {{ adapter.dispatch('extract_email_domain', 'census_utils') (email) }}
{%- endmacro %}

{% macro default__extract_email_domain(email) -%}
    regexp_substr(lower(replace(rtrim({{ email }},'.'),' ','')), '@(.*)', 1, 1)
{%- endmacro %}

{%- macro snowflake__extract_email_domain(email) %}
    regexp_substr(lower(replace(rtrim({{ email }},'.'),' ')), '@(.*)', 1, 1, 'e',1)
{%- endmacro -%}

