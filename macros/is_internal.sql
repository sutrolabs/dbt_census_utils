{% macro is_internal(email=None,ip_address=null) -%}
    {{ adapter.dispatch('is_internal', 'census_utils') (email,ip_address) }}
{%- endmacro %}

    {% macro default__is_internal(email=None,ip_address=null) -%}
        --need to add IP, with option to not use it
        {{ log(var("internal_ip_column"), info=true) }}
        {{ log(ip_address, info=true) }}

        {% if email is not none %}
        {%- set internal_email = dbt_utils.get_column_values(table=ref(var("internal_email_relation")), column=var("internal_email_column")) -%}
        {%- endif -%}
        
        {% if ip_address %}
        {%- set exclusion = var("internal_ip_column") ~ ' is not null' -%}
         {{ log(exclusion, info=true) }}
        {%- set internal_ip = dbt_utils.get_column_values(table=ref(var("internal_ip_relation")), column=var("internal_ip_column"), where=exclusion) -%}
        {%- endif -%}

        case
            {% if email is not none %}
            when {{ census_utils.extract_email_domain(email) }} = '{{ var("internal_domain") }}' then true
            when array_contains({{ email }}::variant, {{internal_email}}) then true
            {%- endif -%}
            {% if ip_address %}
            when array_contains({{ ip_address }}::variant, {{internal_ip}}) then true
            {%- endif %}
            else false end

    {%- endmacro %}