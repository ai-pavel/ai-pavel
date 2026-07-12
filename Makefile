.PHONY: up down restart ps logs build rebuild pull logs-follow test \
        dns-resolver raft-consensus

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

# Integration tests (Hurl suites in tests/, one directory per service).
# Run everything: make test
# Run one suite:  make test-<service>, e.g. make test-sql-parser
test:
	hurl --test tests/*/*.hurl

test-%:
	hurl --test tests/$*/*.hurl

# One-shot / interactive tools
dns-resolver:
	docker compose run --rm dns-resolver $(ARGS)

raft-consensus:
	docker compose run --rm raft-consensus

# Short aliases for service names, used by the up-% and logs-% patterns.
# Services without an alias (redis, dashboard) are addressed by full name.
search    := search-engine
block     := block-indexer
rate      := rate-limiter-service
scheduler := job-scheduler
kv        := distributed-kvstore
mempool   := tx-mempool-simulator
cms       := markdown-cms
pdf       := pdf-generator
sql       := sql-parser
stream    := stream-processor
gossip    := p2p-gossip-protocol

# Start an individual service: make up-<alias|service>, e.g. make up-cms
up-%:
	docker compose up -d $(or $($*),$*)

# Tail logs for an individual service: make logs-<alias|service>
logs-%:
	docker compose logs -f --tail=100 $(or $($*),$*)