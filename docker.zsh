# if ! docker inspect mongodb >/dev/null 2>&1; then
#     docker create --name mongodb -p 27017:27017 mongo
# fi
# if ! docker inspect redisdb >/dev/null 2>&1; then
#     docker create --name redisdb -p 6379:6379 redis
# fi
# if ! docker inspect rabbitmq >/dev/null 2>&1; then
#     docker create --name rabbitmq -p 5672:5672 -p 15672:15672 rabbitmq:management
# fi

# docker start mongodb redisdb rabbitmq >/dev/null