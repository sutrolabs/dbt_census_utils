{% macro parse_ga4_client_id(client_id,extract_value) -%}
    {{ adapter.dispatch('parse_ga4_client_id', 'census_utils') (client_id,extract_value) }}
{%- endmacro %}

    
{% macro default__parse_ga4_client_id(client_id,extract_value) -%}
    {%- if extract_value == 'unique_id' -%}
        split({{ client_id }}, '.')[offset(2)]
    {%- elif extract_value == 'timestamp' -%}
        split({{ client_id }}, '.')[offset(3)]
    {%- elif extract_value == 'client_id' -%}
        replace({{ client_id }}, 'GA1.2.','')
    {% endif %}
{%- endmacro %}