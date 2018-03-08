#!/bin/sh

openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -keyout vault-ui.key -out vault-ui.crt -subj "/C=GB/O=vault/CN=vault-ui"

cat <<EOF > /app/config.hcl
listener "tcp" {
  address       = ":8000"
  tls_cert_file = "/app/vault-ui.crt"
  tls_key_file  = "/app/vault-ui.key"
}

vault {
  address        = "${VAULT_ADDR}"
  runtime_config = "secret/security/goldfish"
  approle_id     = "security_goldfish"
}
EOF

/app/goldfish -config=/app/config.hcl
