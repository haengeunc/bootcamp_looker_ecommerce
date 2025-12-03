view: order_items {
  sql_table_name: `bigquery-public-data.thelook_ecommerce.order_items` ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_at ;;
  }
  dimension_group: delivered {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.delivered_at ;;
  }
  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }
  dimension: order_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.order_id ;;
  }
  dimension: product_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.product_id ;;
  }
  dimension_group: returned {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.returned_at ;;
  }
  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }
  dimension_group: shipped {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.shipped_at ;;
  }
  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }
  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  ######--------- measure -----------


  measure: count {
    type: count
    label: "Count of Order Items"
    drill_fields: [detail*]
  }

  measure: count_item_sold{
    label: "Count of Items Sold"
    description: "When an order is placed, the item ordered is immediately marked as sold within the warehouse"
    type: count
    filters: [order_items.status: "Complete, Processing, Shipped"]
  }

  measure: total_sale_price {
    type: sum
    value_format_name: usd
    sql: ${sale_price} ;;
    description: "Total revenue from all items, including returned"
    drill_fields: [detail*]
    html: <font color="blue">{{rendered_value}}</font> ;;
  }


  measure: average_sale_price {
    type: average
    value_format_name: usd
    sql: ${sale_price} ;;
    filters: [order_items.status: "Complete, Processing, Shipped"]
    description: "Average sales from items sold"

    #Format based on the conditions logic
    html: {% if value >= 600 %}
          <font color="green">{{rendered_value}}</font>
          {% elsif value >= 400 and value < 600 %}
          <font color="goldenrod">{{rendered_value}}</font>
          {% else %}
          <font color="red">{{rendered_value}}</font>
          {% endif %} ;;
  }


  measure: website_totalsales {
    type: sum
    sql: ${sale_price} ;;
    filters: [users.traffic_source: "Email"]
    description: "Total sales for users that signed up via email traffic source"
    value_format_name: usd
  }


  measure: first_order {
    type: date
    sql: MIN(${created_date}) ;;

  }

  measure: latest_order {
    type: date
    sql: MAX(${created_date}) ;;

  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
  id,
  users.last_name,
  users.id,
  users.first_name,
  inventory_items.id,
  inventory_items.product_name,
  products.name,
  products.id,
  orders.order_id
  ]
  }

}
