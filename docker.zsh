docker_machine_name="dev"
if [ "$(docker-machine ls $docker_machine_name | grep Running -c )" -eq 0 ]; then
    echo Starting Docker Host
    docker-machine start $docker_machine_name
fi
eval "$(docker-machine env $docker_machine_name)"
echo Docker environment is ready at $(docker-machine ip $docker_machine_name)

if ! docker inspect mongodb >/dev/null 2>&1; then
    docker create --name mongodb -p 27017:27017 mongo
fi
if ! docker inspect redisdb >/dev/null 2>&1; then
    docker create --name redisdb -p 6379:6379 redis
fi
if ! docker inspect rabbitmq >/dev/null 2>&1; then
    docker create --name rabbitmq -p 5672:5672 -p 15672:15672 rabbitmq:management
fi

docker start mongodb redisdb rabbitmq >/dev/null