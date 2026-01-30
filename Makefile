.PHONY: up down ps logs restart clean

up:
	@cp -n .env.example .env 2>/dev/null || true
	docker compose up -d

down:
	docker compose down

ps:
	docker compose ps

logs:
	docker compose logs -f --tail=200

restart:
	docker compose restart

clean:
	# ⚠️ 会删除数据卷（MySQL/PG/Kafka 等数据）
	docker compose down -v
