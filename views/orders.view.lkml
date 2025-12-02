view: orders {
  sql_table_name: `bigquery-public-data.thelook_ecommerce.orders` ;;
  drill_fields: [order_id]

  dimension: order_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.order_id ;;
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
  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }
  dimension: num_of_item {
    type: number
    sql: ${TABLE}.num_of_item ;;
  }
  dimension_group: returned {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.returned_at ;;
  }
  dimension_group: shipped {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.shipped_at ;;
  }


#Time it took to fulfill an order in units of hours, days and weeks - dim group
  dimension_group: fulfillment {
    type:  duration
    intervals:[
      hour,
      day,
      week
    ]
    sql_start:  ${created_raw} ;;
    sql_end: ${shipped_raw} ;;
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

#####################################
#-----MEASURES------------------------

  measure: count {
    type: count
    drill_fields: [order_id, users.last_name, users.id, users.first_name, order_items.count]
  }


  measure: first_order {
    type: date
    sql: MIN(${created_date}) ;;
  }

  measure: latest_order {
    type: date
    sql: MAX(${created_date}) ;;
  }

###### --- Period over period --- ####

  measure: order_count_last_month {
    type: period_over_period
    description: "Order count from the previous month"
    based_on: orders.count
    based_on_time: orders.created_date
    period: month
    kind: previous
    group_label: "Period-over-period"
  }

  measure: order_count_last_year {
    type: period_over_period
    description: "Order count from the previous year"
    based_on: orders.count
    based_on_time: orders.created_month
    period: year
    kind: previous
    group_label: "Period-over-period"
  }

  measure: order_count_last_year_difference {
    type: period_over_period
    description: "Order count change from the previous year"
    based_on: orders.count
    based_on_time: orders.created_month
    period: year
    kind: difference
    group_label: "Period-over-period"
  }

  measure: order_count_last_year_percet_change {
    type: period_over_period
    description: "% change order count from the previous year"
    based_on: orders.count
    based_on_time: orders.created_month
    period: year
    kind: relative_change
    group_label: "Period-over-period"
    value_format_name: "percent_0"
  }




}
