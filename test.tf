variable "objects" {
  type        = list(any)
  description = "list of objects"
  default = [
    {
      id        = "name1"
      attribute = "a"
    },
    {
      id        = "name2"
      attribute = "a,b"
    },
    {
      id        = "name3"
      attribute = "d"
    }
  ]
}

# var.objects[index(var.objects.*.id, "name2")]
# ${lookup(var.objects[1], "id")}


# Console
# [{id = "name1", attribute = "a"}, {id = "name2", attribute = "a,b"}, {id = "name3", attribute = "d"}][index([{id = "name1", attribute = "a"}, {id = "name2", attribute = "a,b"}, {id = "name3", attribute = "d"}].*.id, "name2")]





# variable "rules" {
#   type = list(object({
#     name = string
#     access = string
#   }))

# validation {
#     condition = alltrue([
#       for o in var.rules : contains(["Allow", "Deny"], o.access)
#     ])
#     error_message = "All rules must have access of either Allow or Deny."
#   }
# }



# list object
# dynamic "regions_config" {
#     for_each = var.regions_config
#     content {
#       region_name     = regions_config.value.region_name
#       electable_nodes = regions_config.value.electable_nodes
#       priority        = regions_config.value.priority
#       read_only_nodes = regions_config.value.read_only_nodes
#     }
#   }

# variable "regions_config" {
#   type = set(object({
#     region_name     = string
#     electable_nodes = number
#     priority        = number
#     read_only_nodes = number
#   }))
#   default = (
#     {
#       region_name     = "US_EAST_1"
#       electable_nodes = 3
#       priority        = 7
#       read_only_nodes = 0
#     },
#     {
#       region_name     = "US_EAST_2"
#       electable_nodes = 2
#       priority        = 6
#       read_only_nodes = 0
#     },
#     {
#       region_name     = "US_WEST_1"
#       electable_nodes = 2
#       priority        = 5
#       read_only_nodes = 2
#     }
#   )
# }

#terraform plan -out=plan.tfplan