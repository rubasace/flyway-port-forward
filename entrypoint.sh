#!/usr/bin/env sh

set -x

if [[ -z "${BASELINE_VERSION}" ]]; then
  BASELINE="-baselineOnMigrate=false"
else
  BASELINE="-baselineOnMigrate=true -baselineVersion=${BASELINE_VERSION}"
fi

envsubst < /.kube/config_template > /.kube/config

kubectl port-forward -n ${NAMESPACE} svc/${DB_SVC} ${LOCAL_PORT}:${DB_SVC_PORT}&


flyway -user="${DB_USER}" -password="${DB_PASSWORD}" ${BASELINE} -url=jdbc:${DB_ENGINE}://localhost:"${LOCAL_PORT}"/"${DB_NAME}" -schemas="${DB_NAME}" \
 -locations="${SCRIPT_LOCATIONS}" -connectRetries=20 migrate