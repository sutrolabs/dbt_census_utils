{% macro extract_email_domain(email) -%}
    {{ adapter.dispatch('extract_email_domain', 'census_utils') (email) }}
{%- endmacro %}

    {% macro default__extract_email_domain(email) -%}
    
        {% set sql_statement %}
            select source_ext, target_ext from  {{ref('domain_extension_cleanup') }}
        {% endset %}

        {%- set domain_extensions = dbt_utils.get_query_results_as_dict(sql_statement) -%}
        
        case 
            when contains_substr(regexp_substr(lower(replace(rtrim({{ email }},'.'),' ','')), '@(.*)', 1, 1),'.') = true 
                then regexp_substr(lower(replace(rtrim({{ email }},'.'),' ','')), '@(.*)', 1, 1)

            {% for extension in domain_extensions['source_ext'] -%}
                when regexp_contains(regexp_substr(lower(replace(rtrim({{ email }},'.'),' ','')), '@(.*)', 1, 1),'[^.]{{extension}}$') 
                    then regexp_replace(regexp_substr(lower(replace(rtrim({{ email }},'.'),' ','')), '@(.*)', 1, 1),'{{extension}}$', '{{domain_extensions["target_ext"][loop.index -1 ]}}')
            {% endfor %}
        end
    {%- endmacro %}

    {%- macro snowflake__extract_email_domain(email) %}
        regexp_substr(lower(replace(rtrim({{ email }},'.'),' ')), '@(.*)', 1, 1, 'e',1)
    {%- endmacro -%}
