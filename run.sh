#!/usr/bin/env bash

set -Eeuo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

if [[ -f .env ]]; then
	set -a
	source .env
	set +a
else
	echo "Missing .env file." >&2
	exit 1
fi

docker compose up --build --detach --wait

docker compose exec -T db psql \
	-U "${dashboard_DATABASE_USER}" \
	-d "${dashboard_DATABASE_NAME}" \
	-f /docker-entrypoint-initdb.d/init.sql

echo "Dashboard services are running."
echo "pgAdmin: http://localhost:5050"
echo "PostgreSQL: localhost:5432"
