{%- macro clean_name(name, type='facebook') %}
{%- if type == 'facebook' -%}
regexp_replace(translate(lower(name), 'ůțąðěřšžųłşșýźľňèéëêēėęàáâäæãåāîïíīįìôöòóœøōõûüùúūñńçćč','utaoerszutssyzlneeeeeeaaaaaaaaiiiiiioooooooouuuuunnccc'),'[^a-z]','')
{% else %}
    name
{% endif %}
{%- endmacro -%}

