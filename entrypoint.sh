#!/bin/sh

openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -keyout goldfish.key -out goldfish.crt -subj "/C=GB/O=vault/CN=goldfish"

cat <<EOF > /app/config.hcl
listener "tcp" {
  address       = ":8000"

  certificate "local" {
    cert_file = "/app/goldfish.crt"
    key_file  = "/app/goldfish.key"
  }
}

vault {
  address        = "${VAULT_ADDR}"
  runtime_config = "secret/security/goldfish"
  approle_id     = "security_goldfish"
}
EOF

/app/goldfish -config=/app/config.hcl
