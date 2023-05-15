{%- macro clean(field, destination='facebook',type='name') %}


    {%- if type == 'name' -%}
        trim(lower({{ field }}))
    {%- elif type == 'email' and destination != 'google' -%}
        trim(lower({{ field }}))
    {%- elif type == 'email' and destination == 'google' -%}
        trim(lower(
            case when {{ census_utils.extract_email_domain(field) }} = 'gmail.com' or {{ census_utils.extract_email_domain(field) }} = 'googlemail.com'
                then replace(replace({{ field }}, {{ census_utils.extract_email_domain(field) }},''),'.','') ||  {{ census_utils.extract_email_domain(field) }}
                else {{ field }}
                end
        ))
    {%- elif type == 'country' and destination == 'google' -%}
        {{ census_utils.get_country_code(field) }}
    {%- elif type == 'country' and destination == 'facebook' -%}
        lower({{ census_utils.get_country_code(field) }})
    {%- elif type == 'city' and destination == 'facebook' -%}
        regexp_replace(translate(lower({{ field }}), 'ůțąðěřšžųłşșýźľňèéëêēėęàáâäæãåāîïíīįìôöòóœøōõûüùúūñńçćč','utaoerszutssyzlneeeeeeaaaaaaaaiiiiiioooooooouuuuunnccc'),'[^a-z]','')
    {%- elif type == 'zip' and destination == 'facebook' -%}
        {# Google can accept 9 digit zip codes but Facebook cannot. #}
        trim(left({{ field }}, 5))
    {%- elif type == 'zip' and destination == 'google' -%}
        trim({{ field }})
    {% else %}
        {%- set error_message = '
        Warning: the `clean` macro does not accept the combination of destination {} and type {}.  The {}.{} model triggered this warning. \
        '.format(type, destination, model.package_name, model.name) -%}

        {%- do exceptions.raise_compiler_error(error_message) -%}
        {{ field }}
    {% endif %}
{%- endmacro -%}


