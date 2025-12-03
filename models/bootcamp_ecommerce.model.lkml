connection: "bigquery_connection"

# include all the views
# include: "/views/**/*.view.lkml"
include: "/explores/explore_orders_customers.explore"
include: "/explores/explore_inventory_products.explore.lkml"
include: "/explores/explore_events_users.explore.lkml"


include: "/dashboards/overview.dashboard.lookml"
include: "/dashboards/products.dashboard.lookml"


datagroup: bootcamp_ecommerce_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: bootcamp_ecommerce_default_datagroup


##--------------------------------------
