#!/usr/bin/with-contenv bashio

ACCOUNT=$(bashio::config 'account')
DOMAINS=$(bashio::config 'domains')
KEYFILE=$(bashio::config 'keyfile')
CERTFILE=$(bashio::config 'certfile')
CHALLENGE_ALIAS=$(bashio::config 'challenge_alias')
DNS_PROVIDER=$(bashio::config 'dns.provider')
DNS_ENVS=$(bashio::config 'dns.env')

for env in $DNS_ENVS; do
    export $env
done

DOMAIN_ARR=()
for domain in $DOMAINS; do
    DOMAIN_ARR+=(--domain "$domain")
done

set -x

/root/.acme.sh/acme.sh --register-account -m ${ACCOUNT}

arguments=()
arguments+=(--issue "${DOMAIN_ARR[@]}")
arguments+=(--dns "$DNS_PROVIDER")
test -n "${CHALLENGE_ALIAS}" && arguments+=(--challenge-alias "${CHALLENGE_ALIAS}")
/root/.acme.sh/acme.sh "${arguments[@]}"

/root/.acme.sh/acme.sh --install-cert "${DOMAIN_ARR[@]}" \
--fullchain-file "/ssl/${CERTFILE}" \
--key-file "/ssl/${KEYFILE}" \

tail -f /dev/null
