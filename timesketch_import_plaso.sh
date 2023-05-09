#!/bin/sh
#
# Run this script with timesketch_import_plaso.sh plaso_file [timesketch_container]
# original script from here: https://dev.to/wincentbalin/how-to-import-large-plaso-file-into-timesketch-in-docker-5afc
# fixed some bash and psort syntax.


if [ $# -eq 0 ]
then
    echo Run this script with "$0" plaso_file \[timesketch_container\]
    exit 1
fi

DOCKER_PATH="/tmp/$(basename "$1")"
TIMELINE="$(echo "$1" | sed -e 's/\.[^.]*$//')"
CONTAINER=docker_timesketch_1
if [ -n "$2" ]
then
    CONTAINER=$2
fi

docker cp "$1" "$CONTAINER:/tmp"
docker exec -it "$CONTAINER" psort.py -o opensearch_ts --timeline_id 99 --server opensearch "$DOCKER_PATH"
docker exec -it "$CONTAINER" rm "$DOCKER_PATH"
