{%- macro clean_name(name, type='facebook') %}
{%- if type == 'facebook' -%}
regexp_replace(translate(lower(name), 'ůțąðěřšžųłşșýźľňèéëêēėęàáâäæãåāîïíīįìôöòóœøōõûüùúūñńçćč','utaoerszutssyzlneeeeeeaaaaaaaaiiiiiioooooooouuuuunnccc'),'[^a-z]','')
{%- elif type == 'google' -%}
trim(lower(name))

{% else %}
    {%- set error_message = '
    Warning: the `clean_name` macro only accepts facebook or google as a type.  The {}.{} model triggered this warning. \
    '.format(model.package_name, model.name) -%}

    {%- do exceptions.raise_compiler_error(error_message) -%}
    name
{% endif %}
{%- endmacro -%}

