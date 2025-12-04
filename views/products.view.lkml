view: products {
  sql_table_name: `bigquery-public-data.thelook_ecommerce.products` ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

#----------------------------------------------------------
#-------Create external links to navigate to explore/google/dashboard
  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;

    link: {
      label: "Google"
      url: "http://www.google.com/search?q={{ value }}"
      icon_url: "http://google.com/favicon.ico"
    }
    link: {
      label: "Facebook"
      url: "https://www.facebook.com/{{value}}/"
      icon_url: "https://facebook.com/favicon.ico"
    }
    link: {
      label: "Order Items Explore"
      url: "https://cntxtdeliveryteam.cloud.looker.com/explore/bootcamp_ecommerce/order_items?fields=order_items.count,users.count,products.brand&f[products.brand]={{ value }}&sorts=order_items.count_order+desc+0&limit=500"
    }
    link: {
      label: "Brand Comparisons Dashboard"
      url: "https://cntxtdeliveryteam.cloud.looker.com/dashboards/3?Category={{_filters['products.category']|url_encode}}&Brand={{ value | url_encode}}"
    }
  }

#----------------------------------------------------------



  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }
  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }
  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }
  dimension: distribution_center_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.distribution_center_id ;;
  }
  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }
  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  dimension: retail_price_group {
    type: tier
    sql: ${retail_price} ;;
    tiers: [0,50,100,150,200,250,300]
    style:  integer
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  #####################################
#-----MEASURES------------------------


  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: gross_margin {
    type: sum
    sql: ${retail_price} - ${cost} ;;
    value_format_name: gbp
  }

  #####################################
#-----MEASURES------------------------

  parameter: retail_price_bucket_size {
    type: number
  }

  dimension: retail_dynamic_price_group {
    type: number
    sql: TRUNC(${retail_price} / {% parameter ${retail_price_bucket_size}%})
      * {% parameter ${retail_price_bucket_size}%} ;;
  }


  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
  id,
  name,
  distribution_centers.name,
  distribution_centers.id,
  inventory_items.count,
  order_items.count
  ]
  }

}
