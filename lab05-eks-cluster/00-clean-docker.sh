# remove images
docker images -q | xargs docker rmi || true 2> /dev/null