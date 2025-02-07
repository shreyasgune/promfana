
#only needed if you have child hcl files and need to inherit the parent
// include {
//     path = find_in_parent_folders()
// }


remote_state {
    backend = "gcs"
    generate = {
      path = "backend.tf"
      if_exists = "overwrite"
    }
    config = {
      bucket = "gman-tf-state-bucket-01"
      prefix = "${path_relative_to_include("root")}/state"
    }
}
