select
    c."Location Code",
    a."Date and Time"::date as "Change Date",
    a."Time"::time as "Change Time",
    a."User ID",
    'Production Order Routing Lines' as "Table",
    'Routing Link Code' as "Field",
    'Modification' as "Change Type",
    'Released' as "Order Status",
    a."Primary Key Field 2 Value" as "Order No_",
    c."Source No_",
    c."Description" as "Order Description",
    a."Primary Key Field 3 Value" as "Order Line",
    d."Item No_" as "Item (OF)",
    d."Description" as "Item (OF) Description",
    f."Inventory Posting Group" as "Item (OF) Type",
    g."Description" as "Technical Family",
    e."Work Center No_",
    e."Operation No_",
    e."No_" as "Machine Center",
    e."Description" as "Machine Center Name",
    a."Old Value",
    a."New Value",
    e."Routing Link Code" as "Current Route Link"
from nav.tbl_int_change_log_entry as a

join lateral (
    select (array(select (regexp_matches(a."Primary Key", '\(([^)]+)\)', 'g'))[1]))[5] as operation_no
) as b
on true

left join nav.tbl_int_production_order as c
on a."Primary Key Field 2 Value" = c."No_"

left join nav.tbl_int_prod_order_line as d
on a."Primary Key Field 2 Value" = d."Prod_ Order No_" and a."Primary Key Field 3 Value"::int = d."Line No_"

left join nav.tbl_int_prod_order_routing_line as e
on a."Primary Key Field 2 Value" = e."Prod_ Order No_" and a."Primary Key Field 3 Value"::int = e."Routing Reference No_" and b.operation_no = e."Operation No_"

left join nav.tbl_int_item as f
on d."Item No_" = f."No_"

left join nav.tbl_int_technical_family_ as g
on f."Technical Family" = g."Code"

where a."Date and Time"::date between '2021-01-01'::date and '2022-01-10'::date and a."Table No_" = 5409 and a."Field No_" = 34 and
    a."Type of Change" = 1 and nullif(a."Old Value",'') is not null and nullif(a."New Value",'') is null and a."Primary Key Field 1 Value" = '3'

order by c."Location Code" asc, a."Date and Time" asc;