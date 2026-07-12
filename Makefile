.PHONY: up down restart ps logs build rebuild pull logs-follow \
        dns-resolver raft-consensus \
        up-search up-block up-redis up-rate up-scheduler up-kv up-mempool up-cms up-pdf up-sql up-stream up-dashboard up-gossip \
        logs-search logs-block logs-redis logs-rate logs-scheduler logs-kv logs-mempool logs-cms logs-pdf logs-sql logs-stream logs-dashboard logs-gossip

# Default target: start the whole stack
up:
	docker compose up -d

down:
	docker compose down

restart:
	docker compose restart

ps:
	docker compose ps

build:
	docker compose build

rebuild:
	docker compose build --no-cache

pull:
	docker compose pull

logs:
	docker compose logs -f --tail=100

# One-shot / interactive tools
dns-resolver:
	docker compose run --rm dns-resolver $(ARGS)

raft-consensus:
	docker compose run --rm raft-consensus

# Start individual services
up-search:
	docker compose up -d search-engine

up-block:
	docker compose up -d block-indexer

up-redis:
	docker compose up -d redis

up-rate:
	docker compose up -d rate-limiter-service

up-scheduler:
	docker compose up -d job-scheduler

up-kv:
	docker compose up -d distributed-kvstore

up-mempool:
	docker compose up -d tx-mempool-simulator

up-cms:
	docker compose up -d markdown-cms

up-pdf:
	docker compose up -d pdf-generator

up-sql:
	docker compose up -d sql-parser

up-stream:
	docker compose up -d stream-processor

up-dashboard:
	docker compose up -d dashboard

up-gossip:
	docker compose up -d p2p-gossip-protocol

# Tail logs for individual services
logs-search:
	docker compose logs -f --tail=100 search-engine

logs-block:
	docker compose logs -f --tail=100 block-indexer

logs-redis:
	docker compose logs -f --tail=100 redis

logs-rate:
	docker compose logs -f --tail=100 rate-limiter-service

logs-scheduler:
	docker compose logs -f --tail=100 job-scheduler

logs-kv:
	docker compose logs -f --tail=100 distributed-kvstore

logs-mempool:
	docker compose logs -f --tail=100 tx-mempool-simulator

logs-cms:
	docker compose logs -f --tail=100 markdown-cms

logs-pdf:
	docker compose logs -f --tail=100 pdf-generator

logs-sql:
	docker compose logs -f --tail=100 sql-parser

logs-stream:
	docker compose logs -f --tail=100 stream-processor

logs-dashboard:
	docker compose logs -f --tail=100 dashboard

logs-gossip:
	docker compose logs -f --tail=100 p2p-gossip-protocol