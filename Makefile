WEEK ?= $(shell date +%V)
YEAR ?= $(shell date +%Y)
DAY ?= $(shell date +%F)
TAG   ?= $(shell git log -1 --abbrev=10 --format=%h)

# Update the specified dependencies
install:
	@command -v ruby >/dev/null 2>&1 || { echo >&2 "I require ruby but it's not installed. Aborting."; exit 1; }
	@command -v bundle >/dev/null 2>&1 || gem install bundler;
	bundle check || bundle install

# Run all the tests
test: bundler
	bundle exec rake spec

help:
	bundle exec bin/client.rb --help

tasks:
	bundle exec bin/client.rb --tasks

myself:
	bundle exec bin/client.rb --myself

# Fill actions
current_week:
	bundle exec bin/client.rb --fill --current-week

week:
	bundle exec bin/client.rb --fill --year=$(YEAR) --week=$(WEEK)

today:
	bundle exec bin/client.rb --fill --today

day:
	bundle exec bin/client.rb --fill --day=$(DAY)

# Submit actions
submit-current-week:
	bundle exec bin/client.rb --submit --current-week

submit-week:
	bundle exec bin/client.rb --submit --year=$(YEAR) --week=$(WEEK)

submit-day:
	bundle exec bin/client.rb --submit --day=$(DAY)

submit-today:
	bundle exec bin/client.rb --submit --today

# Private - ensure gems are up-to-date
bundler:
	bundle check>/dev/null || bundle install

docker-build-image:
	docker images | grep capitainetrain/dovico | grep $(TAG) || docker build --force-rm -t capitainetrain/dovico:$(TAG) -f Dockerfile .

# Run tests in Docker image
docker-test: docker-build-image
	docker run --rm capitainetrain/dovico:$(TAG) test


.PHONY: install test help tasks myself current_week week today day submit-current-week submit-week submit-day submit-today bundler docker-build-image docker-test
