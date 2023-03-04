{% macro extract_email_domain(email) -%}
    {{ adapter.dispatch('extract_email_domain', 'census_utils') (email) }}
{%- endmacro %}

{% macro default__extract_email_domain(email) -%}
    {%- set domain_extensions = {"com":".com", "coin":".co.in", "us":".us","uk":".uk","in":".in"} -%}
    case 
        when contains_substr(regexp_substr(lower(replace(rtrim({{ email }},'.'),' ','')), '@(.*)', 1, 1),'.') = true then regexp_substr(lower(replace(rtrim({{ email }},'.'),' ','')), '@(.*)', 1, 1)
    {% for extension,newext in domain_extensions.items() %}
        when regexp_contains(regexp_substr(lower(replace(rtrim({{ email }},'.'),' ','')), '@(.*)', 1, 1),'[^.]{{extension}}$') then regexp_replace(regexp_substr(lower(replace(rtrim({{ email }},'.'),' ','')), '@(.*)', 1, 1),'{{extension}}$','{{newext}}')
    {% endfor %}
    end
{%- endmacro %}

{%- macro snowflake__extract_email_domain(email) %}
    regexp_substr(lower(replace(rtrim({{ email }},'.'),' ')), '@(.*)', 1, 1, 'e',1)
{%- endmacro -%}

