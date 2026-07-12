# Makefile — docker compose aliases for the local dev stack.
#
# Usage:
#   make up            bring the full stack up (detached)
#   make down          stop and remove containers
#   make restart       restart all services
#   make ps            list running services
#   make logs          tail logs for all services
#   make build         (re)build all service images
#   make rebuild       rebuild all service images without cache
#   make pull          pull base images
#   make dashboard     open the Gatus health dashboard in the browser
#   make test          run all Hurl integration suites (HTML report in `reports/`)
#   make up-<svc>      start one service:            `make up-kv`, `make up-cms`
#   make logs-<svc>    tail logs for one service:    `make logs-search
#   make test-<svc>    run one service's test suite: `make test-mempool`
#   make redis-cli     redis-cli into the shared redis container

COMPOSE := docker compose

.PHONY: up down restart ps logs build rebuild pull test dashboard dns-resolver raft-consensus

# Default target: start the whole stack
up:
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

restart:
	$(COMPOSE) restart

ps:
	$(COMPOSE) ps

build:
	$(COMPOSE) build

rebuild:
	$(COMPOSE) build --no-cache

pull:
	$(COMPOSE) pull

logs:
	$(COMPOSE) logs -f --tail=200

# Open the Gatus health dashboard in the browser
dashboard:
	open http://localhost:8090

# Integration tests (Hurl suites in tests/, one directory per service).
# Writes an HTML report to reports/ (view with: open reports/index.html).
# The directory is wiped first so the report always reflects the latest run.
test:
	rm -rf reports
	hurl --test --report-html reports tests/*/*.hurl

# One-shot / interactive tools
redis-cli:
	docker compose exec redis redis-cli

dns-resolver:
	$(COMPOSE) run --rm dns-resolver $(ARGS)

raft-consensus:
	$(COMPOSE) run --rm raft-consensus

# Short aliases for service names, used by the up-%, logs-% and test-% patterns.
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
	$(COMPOSE) up -d $(or $($*),$*)

# Tail logs for an individual service: make logs-<alias|service>
logs-%:
	$(COMPOSE) logs -f --tail=100 $(or $($*),$*)

# Run one service's integration test suite: make test-<alias|service>,
# e.g. make test-sql or make test-sql-parser
test-%:
	hurl --test tests/$(or $($*),$*)/*.hurl
