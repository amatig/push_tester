#!/bin/bash

# Development server: api.sandbox.push.apple.com:443
#
# Production server: api.push.apple.com:443

ENDPOINT=https://api.sandbox.push.apple.com:443
URLPATH=/3/device/

BUNDLEID="com.teliqo.teliqopip.ft01.voip"
DEVICETOKEN="$1"

URL=$ENDPOINT$URLPATH$DEVICETOKEN

JWT="`./script.sh`"

curl -v \
  --http2 \
  --header "authorization: bearer $JWT" \
  --header "apns-topic: ${BUNDLEID}" \
   --data '{"aps":{"alert":"Notification Hub test notification"}}' \
  "${URL}"

echo ""