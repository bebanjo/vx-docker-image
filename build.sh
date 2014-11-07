set -x

VERSION=$(cat version.txt)

case $1 in
  push)
    echo docker push vexor/trusty:${VERSION}
    docker push vexor/trusty:${VERSION}
    ;;
  *)
    cd docker/trusty
    echo docker build -t vexor/trusty:${VERSION} .
    docker build --rm --no-cache -t vexor/trusty:${VERSION} .
    ;;
esac
