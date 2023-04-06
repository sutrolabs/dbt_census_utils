{{ config(materialized="view") }}

select 
    'GA1.2.1213337569.1677539575' as ga4_client_id,
    '1213337569' as unique_id,
    '1677539575' as timestamp,
    '1213337569.1677539575' as client_id
