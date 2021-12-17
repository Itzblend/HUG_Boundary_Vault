path "auth/token/lookup-self" {
	capabilities = ["read"]
}

path "auth/token/renew-self" {
	capabilities = ["update"]
}

path "auth/token/revoke-self" {
	capabilities = ["update"]
}

path "sys/leases/renew" {
	capabilities = ["update"]
}

path "sys/leases/revoke" {
	capabilities = ["update"]
}

path "kv/*" {
    capabilities = ["read", "list", "update"]
}

path "postgres/*" {
    capabilities = ["read", "list", "update"]
}