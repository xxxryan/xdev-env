# xdev-env

Local dev environment via Docker Compose (macOS + OrbStack friendly).

## Quick start

```bash
cp .env.example .env
make up
make ps
```

## Endpoints

- MySQL: localhost:3306

    - root: root / $MYSQL_ROOT_PASSWORD

    - app user: $MYSQL_USER / $MYSQL_PASSWORD

- Redis: localhost:6379 (password: $REDIS_PASSWORD)

- PostgreSQL: localhost:5432

- Kafka:

    - internal (docker): kafka:9092

    - external (host): localhost:19092

- etcd: localhost:2379

- Registry: localhost:5000

## Examples

### MySQL

```bash
mysql -h 127.0.0.1 -P 3306 -uroot -p
```

### Redis

```bash
redis-cli -h 127.0.0.1 -p 6379 -a redispass ping
```

### Postgres

```bash
psql "postgresql://app:apppass@127.0.0.1:5432/appdb"
```

### Kafka topic demo

```bash
./scripts/kafka-topic-demo.sh
```

### Reset everything (delete volumes)

```bash
make clean
```
