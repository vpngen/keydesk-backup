#!/bin/sh

BRIGADES_BASE_DIR=/home
BRIGADE_DB_FILE=brigade.json
BRIGADE_DB_FILE_DEPT=2
BACKUP_HOST="::1"
BACKUP_PORT=514

for brigade in $(find \
        "${BRIGADES_BASE_DIR}" \
        -maxdepth "${BRIGADE_DB_FILE_DEPT}" \
        -mindepth "${BRIGADE_DB_FILE_DEPT}" \
        -type f \
        -name "${BRIGADE_DB_FILE}" \
        -print | awk -F/ '{print $3}'); do

        (\
                echo -n "[LEA-BRIGADE-BACKUP:${brigade}]" \
                && xz -9 < "${BRIGADES_BASE_DIR}/${brigade}/brigade.json" | base64 -w 0 \
        ) | logger -n "${BACKUP_HOST}" -P "${BACKUP_PORT}" -T
done

