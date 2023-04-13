{% macro is_internal(email=none,ip_address=none) -%}
    {{ adapter.dispatch('is_internal', 'census_utils') (email,ip_address) }}
{%- endmacro %}

{% macro default__is_internal(email=none,ip_address=none) -%}

    case
        when 1 = 2 then true
        {% if email %}
            {%- set exclusion = var("internal_email_column", 'email_address') ~ ' is not null' -%}
            {% if var("internal_email_relation", false)%}
                {%- set internal_email = dbt_utils.get_column_values(table=ref(var("internal_email_relation")), column=var("internal_email_column", 'email_address'), where=exclusion) -%}
                when array_contains({{ email }}::variant, {{internal_email}}) then true
            {%- endif %}
                {% if var("internal_domain", false) %}
                    when {{ census_utils.extract_email_domain(email) }} in {{ var("internal_domain") }} then true
                {%- endif %}
            {%- endif %}
        {% if ip_address and var("internal_ip_relation", false) %}
            {%- set exclusion = var("internal_ip_column", 'ip_address') ~ ' is not null' -%}
            {%- set internal_ip = dbt_utils.get_column_values(table=ref(var("internal_ip_relation")), column=var("internal_ip_column", 'ip_address'), where=exclusion) -%}
            when array_contains({{ ip_address }}::variant, {{internal_ip}}) then true
        {%- endif %}
        else false end

{%- endmacro %}


{% macro bigquery__is_internal(email=none,ip_address=none) -%}

    case
        when 1 = 2 then true
        {% if email %}
            {%- set exclusion = var("internal_email_column", 'email_address') ~ ' is not null' -%}
            {% if var("internal_email_relation", false)%}
                {%- set internal_email = dbt_utils.get_column_values(table=ref(var("internal_email_relation")), column=var("internal_email_column", 'email_address'), where=exclusion) -%}
                when {{ email }} in unnest({{ internal_email }}) then true
            {%- endif %}

            {% if var("internal_domain", false) %}
                when {{ census_utils.extract_email_domain(email) }} in {{ var("internal_domain") }} then true
            {%- endif %}
        {%- endif %}
        {% if ip_address and var("internal_ip_relation", false) %}
            {%- set exclusion = var("internal_ip_column", 'ip_address') ~ ' is not null' -%}
            {%- set internal_ip = dbt_utils.get_column_values(table=ref(var("internal_ip_relation")), column=var("internal_ip_column", 'ip_address'), where=exclusion) -%}
            when {{ ip_address }}  in unnest({{internal_ip}}) then true
        {%- endif %}
        else false end
{% endmacro %}

{% macro redshift__is_internal(email=none,ip_address=none) -%}


    case
        when 1 = 2 then true
        {% if email %}
            {%- set exclusion = var("internal_email_column", 'email_address') ~ ' is not null' -%}
            {% if var("internal_email_relation", false)%}
                {%- set internal_email = dbt_utils.get_column_values(table=ref(var("internal_email_relation")), column=var("internal_email_column", 'email_address'), where=exclusion)|join(',') -%}
                when charindex({{ email }},'{{internal_email}}') > 0 then true
            {%- endif %}

            {% if var("internal_domain", false) %}
                when {{ census_utils.extract_email_domain(email) }} in {{ var("internal_domain") }} then true
            {%- endif %}
        {%- endif %}
        {% if ip_address and var("internal_ip_relation", false) %}
            {%- set exclusion = var("internal_ip_column", 'ip_address') ~ ' is not null' -%}
            {%- set internal_ip = dbt_utils.get_column_values(table=ref(var("internal_ip_relation")), column=var("internal_ip_column", 'ip_address'), where=exclusion)|join(',') -%}
            when charindex({{ ip_address }}, '{{internal_ip}}') > 0 then true
        {%- endif %}
        else false end
{% endmacro %}

