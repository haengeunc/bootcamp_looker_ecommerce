include: "/views/events.view"
include: "/views/users.view"

##--------------------------------------



explore: events {
  join: users {
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}
