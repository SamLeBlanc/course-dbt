{% macro sum_of(col_name, val) %}

sum(case when {{ col_name }} = '{{ val }}' then 1 else 0 end)

{% endmacro %}