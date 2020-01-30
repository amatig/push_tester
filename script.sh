#!/usr/bin/env bash

# your team id located in the developer portal
TEAMID=xxx

# your key id located in the developer portal
KEYID=xxx

# the path to the key file you have stored in a safe place
SECRET="./AuthKey_xxx.p8"

# make input base64 url safe
function base64URLSafe {
  openssl base64 -e -A | tr -- '+/' '-_' | tr -d =
}

# sign input with you key file
function sign {
  printf "$1"| openssl dgst -binary -sha256 -sign "$SECRET" | base64URLSafe
}

# now
time=$(date +%s)

# your header section
# 
# e.g.
# {
#   "alg" : "ES256",
#   "kid" : "ABC123DEFG"
# }
header=$(printf '{ "alg": "ES256", "kid": "%s" }' "$KEYID" | base64URLSafe)

# your claims section
#
# e.g.
# {
#   "iss": "DEF123GHIJ",
#   "iat": 1437179036
# }
claims=$(printf '{ "iss": "%s", "iat": %d }' "$TEAMID" "$time" | base64URLSafe)

# concatenate your header, your claim and a signed version of you header concatenated with your claim
jwt="$header.$claims.$(sign $header.$claims)"

# show it
echo $jwt
