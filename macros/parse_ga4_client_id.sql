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
    {% else %}
    {%- set error_message = '
    Warning: the `parse_ga4_client_id` macro only accepts unique_id, timestamp, or client_id as the extract_value. The {}.{} model triggered this warning. \
    '.format(model.package_name, model.name) -%}

    {%- do exceptions.raise_compiler_error(error_message) -%}
    {% endif %}
{%- endmacro %}

{% macro snowflake__parse_ga4_client_id(client_id,extract_value) -%}
    {%- if extract_value == 'unique_id' -%}
        split_part({{ client_id }}, '.',3)
    {%- elif extract_value == 'timestamp' -%}
        split_part({{ client_id }}, '.',4)
    {%- elif extract_value == 'client_id' -%}
        replace({{ client_id }}, 'GA1.2.','')
    {% else %}
    {%- set error_message = '
    Warning: the `parse_ga4_client_id` macro only accepts unique_id, timestamp, or client_id as the extract_value. The {}.{} model triggered this warning. \
    '.format(model.package_name, model.name) -%}

    {%- do exceptions.raise_compiler_error(error_message) -%}
    {% endif %}
{%- endmacro %}