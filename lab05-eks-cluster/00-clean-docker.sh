# remove images
docker images -q | xargs docker rmi || true