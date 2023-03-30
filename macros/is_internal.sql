{% macro is_internal(email=none,ip_address=none) -%}
    {{ adapter.dispatch('is_internal', 'census_utils') (email,ip_address) }}
{%- endmacro %}

    {% macro default__is_internal(email=none,ip_address=none) -%}

        case
            {% if email %}
            {%- set exclusion = var("internal_email_column") ~ ' is not null' -%}
            {%- set internal_email = dbt_utils.get_column_values(table=ref(var("internal_email_relation")), column=var("internal_email_column"), where=exclusion) -%}
            when {{ census_utils.extract_email_domain(email) }} = '{{ var("internal_domain") }}' then true
            when array_contains({{ email }}::variant, {{internal_email}}) then true
            {%- endif %}
            {% if ip_address %}
            {%- set exclusion = var("internal_ip_column") ~ ' is not null' -%}
            {%- set internal_ip = dbt_utils.get_column_values(table=ref(var("internal_ip_relation")), column=var("internal_ip_column"), where=exclusion) -%}
            when array_contains({{ ip_address }}::variant, {{internal_ip}}) then true
            {%- endif %}
            else false end

    {%- endmacro %}