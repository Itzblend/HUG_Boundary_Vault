listener "tcp" {
    purpose = "proxy"
    tls_disable = true
    address = "192.168.56.5"
}

worker {
  # Name attr must be unique across workers
  name = "demo-worker-1"
  description = "A default worker created demonstration"

  # Workers must be able to reach controllers on :9201
  controllers = [
    "192.168.56.2"
  ]

  #public_addr = "myhost.mycompany.com"

  #tags {
  #  type   = ["prod", "webservers"]
  #  region = ["us-east-1"]
#  }
}

# must be same key as used on controller config
kms "aead" {
    purpose = "worker-auth"
    aead_type = "aes-gcm"
    key = "8fZBjCUfN0TzjEGLQldGY4+iE9AkOvCfjh7+p0GtRBQ="
    key_id = "global_worker-auth"
}
