# Copy contents below 
include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../..//modules/container_services/amazon"
}