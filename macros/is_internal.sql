{% macro is_internal(email=none,ip_address=none) -%}
    {{ adapter.dispatch('is_internal', 'census_utils') (email,ip_address) }}
{%- endmacro %}

    {% macro default__is_internal(email=none,ip_address=none) -%}


        case
            {% if email %}
            {%- set exclusion = var("internal_email_column", 'email_address') ~ ' is not null' -%}
            {%- set internal_email = dbt_utils.get_column_values(table=ref(var("internal_email_relation", 'census_internal_users')), column=var("internal_email_column", 'email_address'), where=exclusion) -%}
            when array_contains({{ census_utils.extract_email_domain(email) }}::variant, {{ dbt.array_construct(var("internal_domain", 'getcensus.com')) }}) then true
            when array_contains({{ email }}::variant, {{internal_email}}) then true
            {%- endif %}
            {% if ip_address %}
            {%- set exclusion = var("internal_ip_column", 'ip_address') ~ ' is not null' -%}
            {%- set internal_ip = dbt_utils.get_column_values(table=ref(var("internal_ip_relation", 'census_internal_users')), column=var("internal_ip_column", 'ip_address'), where=exclusion) -%}
            when array_contains({{ ip_address }}::variant, {{internal_ip}}) then true
            {%- endif %}
            else false end

    {%- endmacro %}