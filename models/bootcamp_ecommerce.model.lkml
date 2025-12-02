connection: "bigquery_connection"

# include all the views
include: "/views/**/*.view.lkml"
include: "/explores/explore_orders_customers.explore"
include: "/explores/explore_inventory_products.explore.lkml"



datagroup: bootcamp_ecommerce_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: bootcamp_ecommerce_default_datagroup





##--------------------------------------

explore: events {
  join: users {
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}
