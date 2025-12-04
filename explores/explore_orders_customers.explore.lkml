include: "/views/users.view"
include: "/views/orders.view"
include: "/views/order_items.view"
include: "/views/products.view"

##--------------------------------------

explore: orders_customers {
  description: "Explore orders placed by customers"

  view_name: order_items

  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: orders {
    type: left_outer
    sql_on: ${order_items.order_id} = ${orders.order_id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${order_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

}


###----------Extends example ----------

# explore: order_items_last_90_days {
#   extends: [order_items]
#   view_name: order_items
#   fields: [ALL_FIELDS*, -order_items.detail*]
#   sql_always_where: ${order_items.created_date} > date_add(current_date(), interval -90 day)  ;;
# }

###----------Refinements example ----------

# explore: +order_items {
#   label: "Simplified Order Items Explore"
#   fields: [order_items.detail* , users.detail*]
# }

###----------Refinements Quick Start example ----------

# explore: +order_items {
#   query: user_count_by_month_in_2024 {
#     description: "No. of orders by month by department (men/women) in 2024"
#     dimensions: [order_items.created_month]
#     measures: [order_items.count]
#     pivots: [users.gender]
#     filters: [order_items.created_date: "2024"]
#   }
# }
