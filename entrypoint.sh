#!/bin/sh

cat <<EOF > /app/config.hcl
listener "tcp" {
  address       = ":8000"
  tls_disable      = 1
}
vault {
  address       = "${VAULT_ADDR}"
}
EOF

/app/goldfish -config=/app/config.hcl
